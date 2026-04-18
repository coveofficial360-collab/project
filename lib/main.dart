import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StitchAvenueApp());
}

class StitchAvenueApp extends StatelessWidget {
  const StitchAvenueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avenue360',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        useMaterial3: true,
      ),
      initialRoute: AppPage.home.routeName,
      onGenerateRoute: (settings) {
        final page = AppPage.fromRoute(settings.name) ?? AppPage.home;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (_, _, _) => HtmlMockupScreen(page: page),
        );
      },
    );
  }
}

enum AppPage {
  home(slug: 'home', assetPath: 'home_with_essential_notifications/code.html'),
  amenities(slug: 'amenities', assetPath: 'amenities/code.html'),
  notices(slug: 'notices', assetPath: 'community_feed_notices/code.html'),
  bills(slug: 'bills', assetPath: 'manage_bills_recharges/code.html'),
  complaints(slug: 'complaints', assetPath: 'my_complaints/code.html'),
  profile(slug: 'profile', assetPath: 'my_profile/code.html'),
  notifications(slug: 'notifications', assetPath: 'notifications/code.html'),
  visitor(slug: 'visitor', assetPath: 'visitor_pre_approval/code.html'),
  drawer(slug: 'drawer', assetPath: 'navigation_drawer/code.html');

  const AppPage({required this.slug, required this.assetPath});

  final String slug;
  final String assetPath;

  String get routeName => '/$slug';

  static AppPage? fromSlug(String? slug) {
    if (slug == null) {
      return null;
    }

    for (final page in values) {
      if (page.slug == slug) {
        return page;
      }
    }

    return null;
  }

  static AppPage? fromRoute(String? routeName) {
    if (routeName == null || routeName.isEmpty || routeName == '/') {
      return home;
    }

    return fromSlug(routeName.replaceFirst('/', ''));
  }
}

class _Binding {
  const _Binding.text(
    this.value,
    this.action, {
    this.selector = 'span,button,a,div',
    this.closest,
    this.matchMode = 'exact',
    this.firstOnly = false,
  }) : type = 'text';

  const _Binding.icon(this.value, this.action, {this.firstOnly = false})
    : type = 'icon',
      closest = null,
      selector = '.material-symbols-outlined',
      matchMode = 'exact';

  const _Binding.selector(this.selector, this.action, {this.firstOnly = false})
    : type = 'selector',
      closest = null,
      value = '',
      matchMode = 'exact';

  final String type;
  final String value;
  final String action;
  final String selector;
  final String? closest;
  final String matchMode;
  final bool firstOnly;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'type': type,
      'value': value,
      'action': action,
      'selector': selector,
      'closest': closest,
      'matchMode': matchMode,
      'firstOnly': firstOnly,
    };
  }
}

class HtmlMockupScreen extends StatefulWidget {
  const HtmlMockupScreen({super.key, required this.page});

  final AppPage page;

  @override
  State<HtmlMockupScreen> createState() => _HtmlMockupScreenState();
}

class _HtmlMockupScreenState extends State<HtmlMockupScreen> {
  static const _appScheme = 'avenue360';

  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _handleNavigation,
          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      );
    unawaited(_loadPage());
  }

  Future<void> _loadPage() async {
    final rawHtml = await rootBundle.loadString(widget.page.assetPath);
    final html = _decorateHtml(rawHtml, _bindingsForPage(widget.page));
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    await _controller.loadHtmlString(html);
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri?.scheme != _appScheme) {
      return NavigationDecision.navigate;
    }

    Future<void>.microtask(() {
      if (!mounted) {
        return;
      }

      if (uri?.host == 'back') {
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          navigator.pushReplacementNamed(AppPage.home.routeName);
        }
        return;
      }

      if (uri?.host == 'navigate') {
        final page = AppPage.fromSlug(uri?.pathSegments.first);
        if (page != null && page != widget.page) {
          Navigator.of(context).pushNamed(page.routeName);
        }
      }
    });

    return NavigationDecision.prevent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              top: true,
              bottom: false,
              child: WebViewWidget(controller: _controller),
            ),
          ),
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0xFFF8F9FA),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  String _decorateHtml(String html, List<_Binding> bindings) {
    final cleanedHtml = html.replaceAll('```html', '');
    final bindingJson = jsonEncode(
      bindings.map((binding) => binding.toJson()).toList(),
    );
    const scriptTemplate = '''
<script>
  (function () {
    const bindings = __BINDINGS__;
    const normalize = (value) => (value || '').replace(/\\s+/g, ' ').trim().toLowerCase();
    const candidates = 'span,button,a,div,img';

    const makeTarget = (node, closest) => {
      if (!node) {
        return null;
      }
      if (!closest) {
        return node;
      }
      return node.closest(closest) || node;
    };

    const addBinding = (node, action) => {
      if (!node || node.dataset.flutterBound === '1') {
        return;
      }
      node.dataset.flutterBound = '1';
      node.addEventListener('click', function (event) {
        event.preventDefault();
        event.stopPropagation();
        window.location.href = action;
      }, true);
    };

    const readText = (node) => {
      if (node.tagName === 'IMG') {
        return node.getAttribute('alt') || '';
      }
      return node.innerText || node.textContent || '';
    };

    const findMatches = (binding) => {
      if (binding.type === 'selector') {
        return Array.from(document.querySelectorAll(binding.selector));
      }

      const nodes = Array.from(
        document.querySelectorAll(binding.selector || candidates),
      );
      const expected = normalize(binding.value);

      return nodes.filter((node) => {
        const actual = normalize(readText(node));
        if (!actual) {
          return false;
        }
        if (binding.type === 'icon') {
          return actual === expected;
        }
        if (binding.matchMode === 'contains') {
          return actual.includes(expected);
        }
        return actual === expected;
      });
    };

    const attachBindings = () => {
      bindings.forEach((binding) => {
        let matches = findMatches(binding);
        if (binding.firstOnly) {
          matches = matches.slice(0, 1);
        }
        matches.forEach((match) => {
          addBinding(makeTarget(match, binding.closest), binding.action);
        });
      });
    };

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', attachBindings);
    } else {
      attachBindings();
    }
  })();
</script>
''';
    final script = scriptTemplate.replaceFirst('__BINDINGS__', bindingJson);

    if (cleanedHtml.contains('</body>')) {
      return cleanedHtml.replaceFirst('</body>', '$script</body>');
    }

    return '$cleanedHtml$script';
  }

  List<_Binding> _bindingsForPage(AppPage page) {
    final back = _actionBack();
    switch (page) {
      case AppPage.home:
        return [
          _Binding.icon(
            'menu',
            _actionNavigate(AppPage.drawer),
            firstOnly: true,
          ),
          _Binding.icon(
            'notifications',
            _actionNavigate(AppPage.notifications),
            firstOnly: true,
          ),
          _Binding.selector(
            'img[alt="User profile photo"]',
            _actionNavigate(AppPage.profile),
            firstOnly: true,
          ),
          _Binding.text(
            'Manage',
            _actionNavigate(AppPage.bills),
            selector: 'a,span',
            closest: 'a',
            matchMode: 'contains',
          ),
          _Binding.text(
            'Pay Now',
            _actionNavigate(AppPage.bills),
            selector: 'button,span',
            closest: 'button',
            firstOnly: true,
          ),
          _Binding.text(
            'Pre-Approve Visitor',
            _actionNavigate(AppPage.visitor),
            selector: 'span,div',
            closest: '.cursor-pointer',
          ),
          _Binding.text(
            'Raise Complaint',
            _actionNavigate(AppPage.complaints),
            selector: 'span,div',
            closest: '.cursor-pointer',
          ),
          _Binding.text(
            'View All',
            _actionNavigate(AppPage.notices),
            selector: 'a,span,button',
            closest: 'a,button',
            matchMode: 'contains',
          ),
          _Binding.text(
            'Home',
            _actionNavigate(AppPage.home),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Amenities',
            _actionNavigate(AppPage.amenities),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Notices',
            _actionNavigate(AppPage.notices),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Complaints',
            _actionNavigate(AppPage.complaints),
            selector: 'span',
            closest: 'a',
          ),
        ];
      case AppPage.drawer:
        return [
          _Binding.selector(
            'img[alt="Profile avatar of Aditya Sharma"]',
            _actionNavigate(AppPage.profile),
            firstOnly: true,
          ),
          _Binding.text(
            'Aditya Sharma',
            _actionNavigate(AppPage.profile),
            selector: 'h2',
            firstOnly: true,
          ),
          _Binding.text(
            'Dashboard',
            _actionNavigate(AppPage.home),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Payments',
            _actionNavigate(AppPage.bills),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'My Complaints',
            _actionNavigate(AppPage.complaints),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Notice Board',
            _actionNavigate(AppPage.notices),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Amenities',
            _actionNavigate(AppPage.amenities),
            selector: 'span',
            closest: 'a',
          ),
        ];
      case AppPage.profile:
        return [
          _Binding.icon('arrow_back', back),
          _Binding.text(
            'Home',
            _actionNavigate(AppPage.home),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Amenities',
            _actionNavigate(AppPage.amenities),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Notices',
            _actionNavigate(AppPage.notices),
            selector: 'span',
            closest: 'a',
          ),
          _Binding.text(
            'Complaints',
            _actionNavigate(AppPage.complaints),
            selector: 'span',
            closest: 'a',
          ),
        ];
      case AppPage.notifications:
        return [
          _Binding.icon('arrow_back', back),
          _Binding.text(
            'Pay Now',
            _actionNavigate(AppPage.bills),
            selector: 'button,span',
            closest: 'button',
            firstOnly: true,
          ),
        ];
      case AppPage.visitor:
        return [
          _Binding.icon('arrow_back', back),
          _Binding.text(
            'Home',
            _actionNavigate(AppPage.home),
            selector: 'span',
            closest: 'a,button',
          ),
          _Binding.text(
            'Services',
            _actionNavigate(AppPage.amenities),
            selector: 'span',
            closest: 'a,button',
          ),
          _Binding.text(
            'Profile',
            _actionNavigate(AppPage.profile),
            selector: 'span',
            closest: 'a,button',
          ),
        ];
      case AppPage.bills:
        return [
          _Binding.icon('arrow_back', back),
          _Binding.text(
            'View All',
            _actionNavigate(AppPage.notifications),
            selector: 'button,span',
            closest: 'button',
            matchMode: 'contains',
          ),
        ];
      case AppPage.complaints:
        return [
          _Binding.icon('arrow_back', back),
          _Binding.selector(
            'img[alt="Resident User"]',
            _actionNavigate(AppPage.profile),
            firstOnly: true,
          ),
          _Binding.text(
            'Home',
            _actionNavigate(AppPage.home),
            selector: 'button,span',
            closest: 'button',
          ),
          _Binding.text(
            'Services',
            _actionNavigate(AppPage.amenities),
            selector: 'button,span',
            closest: 'button',
          ),
          _Binding.text(
            'Profile',
            _actionNavigate(AppPage.profile),
            selector: 'button,span',
            closest: 'button',
          ),
        ];
      case AppPage.amenities:
        return [_Binding.icon('arrow_back', back)];
      case AppPage.notices:
        return [_Binding.icon('arrow_back', back)];
    }
  }

  String _actionNavigate(AppPage page) {
    return Uri(
      scheme: _appScheme,
      host: 'navigate',
      pathSegments: [page.slug],
    ).toString();
  }

  String _actionBack() {
    return Uri(scheme: _appScheme, host: 'back').toString();
  }
}
