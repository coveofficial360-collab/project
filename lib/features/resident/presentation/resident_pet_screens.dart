part of 'resident_screens.dart';

class PetCommunityHubScreen extends StatefulWidget {
  const PetCommunityHubScreen({super.key});

  @override
  State<PetCommunityHubScreen> createState() => _PetCommunityHubScreenState();
}

class _PetCommunityHubScreenState extends State<PetCommunityHubScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<dynamic>> _load() {
    return Future.wait([
      _repository.fetchPetHubSummary(),
      _repository.fetchMyPets(),
      _repository.fetchPetMeetups(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Pets Community',
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppPage.drawer.routeName, arguments: AppPage.petHub),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          final summary = snapshot.hasData
              ? (snapshot.data![0] as Map<String, dynamic>?)
              : null;
          final pets = snapshot.hasData
              ? List<Map<String, dynamic>>.from(snapshot.data![1] as List)
              : const <Map<String, dynamic>>[];
          final meetups = snapshot.hasData
              ? List<Map<String, dynamic>>.from(snapshot.data![2] as List)
              : const <Map<String, dynamic>>[];

          return RefreshIndicator(
            onRefresh: () async {
              final future = _load();
              setState(() => _future = future);
              await future;
            },
            child: _ResidentScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HubHeroCard(
                    totalPets: (summary?['total_pets'] as num?)?.toInt() ?? 0,
                    dueVaccinations:
                        (summary?['vaccinations_due_soon'] as num?)?.toInt() ??
                        0,
                    upcomingBookings:
                        (summary?['upcoming_zone_bookings'] as num?)?.toInt() ??
                        0,
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(
                    title: 'Quick Actions',
                    subtitle: 'Manage your pets and activities',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _HubActionChip(
                        icon: Icons.pets_rounded,
                        label: 'Add Pet',
                        onTap: () => goToPage(context, AppPage.addPetBasicDetails),
                      ),
                      _HubActionChip(
                        icon: Icons.medical_services_rounded,
                        label: 'Vaccinations',
                        onTap: () =>
                            goToPage(context, AppPage.vaccinationDashboard),
                      ),
                      _HubActionChip(
                        icon: Icons.edit_note_rounded,
                        label: 'Create Post',
                        onTap: () => goToPage(context, AppPage.createPetPost),
                      ),
                      _HubActionChip(
                        icon: Icons.groups_rounded,
                        label: 'Meetups',
                        onTap: () => goToPage(context, AppPage.petMeetups),
                      ),
                      _HubActionChip(
                        icon: Icons.park_rounded,
                        label: 'Book Zone',
                        onTap: () => goToPage(context, AppPage.bookPetZone),
                      ),
                      _HubActionChip(
                        icon: Icons.storefront_rounded,
                        label: 'Pet Stores',
                        onTap: () => goToPage(context, AppPage.petStores),
                      ),
                      _HubActionChip(
                        icon: Icons.volunteer_activism_rounded,
                        label: 'Adoption',
                        onTap: () =>
                            goToPage(context, AppPage.petAdoptionCenter),
                      ),
                      _HubActionChip(
                        icon: Icons.local_hospital_rounded,
                        label: 'Vet Directory',
                        onTap: () => goToPage(context, AppPage.vetDirectory),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SectionTitle(title: 'My Pets', subtitle: 'Tap to view profile'),
                  const SizedBox(height: 10),
                  if (pets.isEmpty)
                    const _DataPlaceholderCard(
                      label: 'No pet profiles yet. Add your first pet profile.',
                    )
                  else
                    ...pets.map(
                      (pet) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PetMiniCard(
                          row: pet,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppPage.petProfile.routeName,
                            arguments: {'petId': pet['id']?.toString()},
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  _SectionTitle(
                    title: 'Upcoming Meetups',
                    subtitle: 'Community events around pets',
                  ),
                  const SizedBox(height: 10),
                  if (meetups.isEmpty)
                    const _DataPlaceholderCard(label: 'No meetups scheduled yet.')
                  else
                    ...meetups.take(3).map(
                      (meetup) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SimpleListCard(
                          title: meetup['title']?.toString() ?? 'Meetup',
                          subtitle:
                              '${_calendarDateLabel(meetup['meetup_date'])} • ${meetup['location_label'] ?? '-'}',
                          trailing:
                              (meetup['pet_size_pref']?.toString() ?? 'all')
                                  .toUpperCase(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        currentPage: AppPage.petHub,
        items: _visitorNavItems,
      ),
    );
  }
}

class PetSocialFeedScreen extends StatelessWidget {
  const PetSocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Pet Social Feed',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goToPage(context, AppPage.petHub, replace: true),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchPetSocialPosts(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return _ResidentScrollView(
            child: rows.isEmpty
                ? const _DataPlaceholderCard(label: 'No pet posts yet.')
                : Column(
                    children: rows
                        .map(
                          (row) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SimpleListCard(
                              title: row['title']?.toString() ?? 'Post',
                              subtitle: row['body']?.toString() ?? '',
                              trailing:
                                  '${(row['likes_count'] as num?)?.toInt() ?? 0} likes',
                            ),
                          ),
                        )
                        .toList(),
                  ),
          );
        },
      ),
    );
  }
}

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key, this.petId});
  final String? petId;

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Pet Profile',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goToPage(context, AppPage.petHub, replace: true),
          size: 40,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: petId == null ? Future.value(null) : repository.fetchPetProfile(petId!),
        builder: (context, snapshot) {
          final pet = snapshot.data;
          if (pet == null) {
            return const _ResidentScrollView(
              child: _DataPlaceholderCard(label: 'Pet profile not found.'),
            );
          }

          return _ResidentScrollView(
            child: Column(
              children: [
                _PetMiniCard(row: pet),
                const SizedBox(height: 12),
                _SimpleListCard(
                  title: 'Breed',
                  subtitle: pet['breed']?.toString() ?? '-',
                ),
                const SizedBox(height: 10),
                _SimpleListCard(
                  title: 'Gender',
                  subtitle: pet['gender']?.toString() ?? '-',
                ),
                const SizedBox(height: 10),
                _SimpleListCard(
                  title: 'Allergies',
                  subtitle: pet['allergies']?.toString() ?? 'None noted',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AddPetBasicDetailsScreen extends StatefulWidget {
  const AddPetBasicDetailsScreen({super.key});
  @override
  State<AddPetBasicDetailsScreen> createState() => _AddPetBasicDetailsScreenState();
}

class _AddPetBasicDetailsScreenState extends State<AddPetBasicDetailsScreen> {
  final _name = TextEditingController(text: _PetDraftStore.name);
  final _species = TextEditingController(text: _PetDraftStore.species);
  final _breed = TextEditingController(text: _PetDraftStore.breed);

  @override
  Widget build(BuildContext context) {
    return _PetFormScaffold(
      title: 'Add Pet: Basic Details',
      onNext: () {
        _PetDraftStore.name = _name.text.trim();
        _PetDraftStore.species = _species.text.trim();
        _PetDraftStore.breed = _breed.text.trim();
        goToPage(context, AppPage.addPetHealthInfo);
      },
      child: Column(
        children: [
          _ResidentField(controller: _name, label: 'Pet Name'),
          const SizedBox(height: 12),
          _ResidentField(controller: _species, label: 'Species (dog/cat)'),
          const SizedBox(height: 12),
          _ResidentField(controller: _breed, label: 'Breed'),
        ],
      ),
    );
  }
}

class AddPetHealthInfoScreen extends StatefulWidget {
  const AddPetHealthInfoScreen({super.key});
  @override
  State<AddPetHealthInfoScreen> createState() => _AddPetHealthInfoScreenState();
}

class _AddPetHealthInfoScreenState extends State<AddPetHealthInfoScreen> {
  final _gender = TextEditingController(text: _PetDraftStore.gender);
  final _weight = TextEditingController(text: _PetDraftStore.weightKgText);
  final _allergies = TextEditingController(text: _PetDraftStore.allergies);

  @override
  Widget build(BuildContext context) {
    return _PetFormScaffold(
      title: 'Add Pet: Health Info',
      onNext: () {
        _PetDraftStore.gender = _gender.text.trim();
        _PetDraftStore.weightKgText = _weight.text.trim();
        _PetDraftStore.allergies = _allergies.text.trim();
        goToPage(context, AppPage.addPetPhotoUpload);
      },
      child: Column(
        children: [
          _ResidentField(controller: _gender, label: 'Gender'),
          const SizedBox(height: 12),
          _ResidentField(controller: _weight, label: 'Weight (kg)'),
          const SizedBox(height: 12),
          _ResidentField(controller: _allergies, label: 'Allergies'),
        ],
      ),
    );
  }
}

class AddPetPhotoUploadScreen extends StatefulWidget {
  const AddPetPhotoUploadScreen({super.key});
  @override
  State<AddPetPhotoUploadScreen> createState() => _AddPetPhotoUploadScreenState();
}

class _AddPetPhotoUploadScreenState extends State<AddPetPhotoUploadScreen> {
  final _photoUrl = TextEditingController(text: _PetDraftStore.photoUrl);
  final _bio = TextEditingController(text: _PetDraftStore.bio);

  @override
  Widget build(BuildContext context) {
    return _PetFormScaffold(
      title: 'Add Pet: Photo & Bio',
      onNext: () {
        _PetDraftStore.photoUrl = _photoUrl.text.trim();
        _PetDraftStore.bio = _bio.text.trim();
        goToPage(context, AppPage.addPetPreview);
      },
      child: Column(
        children: [
          _ResidentField(controller: _photoUrl, label: 'Photo URL'),
          const SizedBox(height: 12),
          _ResidentField(controller: _bio, label: 'Bio', maxLines: 3),
        ],
      ),
    );
  }
}

class AddPetPreviewScreen extends StatefulWidget {
  const AddPetPreviewScreen({super.key});
  @override
  State<AddPetPreviewScreen> createState() => _AddPetPreviewScreenState();
}

class _AddPetPreviewScreenState extends State<AddPetPreviewScreen> {
  bool _saving = false;
  final AvenueRepository _repository = AvenueRepository();

  @override
  Widget build(BuildContext context) {
    return _PetFormScaffold(
      title: 'Add Pet: Preview',
      nextLabel: _saving ? 'Saving...' : 'Save Pet Profile',
      onNext: _saving
          ? null
          : () async {
              setState(() => _saving = true);
              try {
                await _repository.createPetProfile(
                  name: _PetDraftStore.name,
                  species: _PetDraftStore.species.isEmpty
                      ? 'dog'
                      : _PetDraftStore.species,
                  breed: _PetDraftStore.breed,
                  gender: _PetDraftStore.gender,
                  weightKg: double.tryParse(_PetDraftStore.weightKgText),
                  allergies: _PetDraftStore.allergies,
                  bio: _PetDraftStore.bio,
                  photoUrl: _PetDraftStore.photoUrl,
                );
                _PetDraftStore.clear();
                if (!mounted) return;
                goToPage(context, AppPage.petHub, replace: true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pet profile created.')),
                );
              } catch (error) {
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(_friendlySupabaseMessage(error))));
              } finally {
                if (mounted) setState(() => _saving = false);
              }
            },
      child: _SimpleListCard(
        title: _PetDraftStore.name.isEmpty ? 'New Pet' : _PetDraftStore.name,
        subtitle:
            '${_PetDraftStore.species} • ${_PetDraftStore.breed}\n${_PetDraftStore.bio}',
      ),
    );
  }
}

class VaccinationDashboardScreen extends StatelessWidget {
  const VaccinationDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _PetListScaffold(
      title: 'Vaccination Dashboard',
      loadRows: repository.fetchPetVaccinations,
      onAdd: () => goToPage(context, AppPage.addVaccination),
      emptyLabel: 'No vaccination records yet.',
      mapTitle: (row) => row['vaccine_name']?.toString() ?? 'Vaccine',
      mapSubtitle: (row) =>
          'Due: ${_calendarDateLabel(row['due_on'])} • Given: ${_calendarDateLabel(row['administered_on'])}',
    );
  }
}

class VaccinationHistoryScreen extends StatelessWidget {
  const VaccinationHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const VaccinationDashboardScreen();
  }
}

class AddVaccinationScreen extends StatefulWidget {
  const AddVaccinationScreen({super.key});
  @override
  State<AddVaccinationScreen> createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final _vaccine = TextEditingController();
  final _dose = TextEditingController();
  bool _saving = false;
  String? _petId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _repository.fetchMyPets(),
      builder: (context, snapshot) {
        final pets = snapshot.data ?? const <Map<String, dynamic>>[];
        _petId ??= pets.isNotEmpty ? pets.first['id']?.toString() : null;
        return _PetFormScaffold(
          title: 'Add Vaccination',
          nextLabel: _saving ? 'Saving...' : 'Save',
          onNext: _saving || _petId == null
              ? null
              : () async {
                  setState(() => _saving = true);
                  try {
                    await _repository.addPetVaccination(
                      petId: _petId!,
                      vaccineName: _vaccine.text.trim(),
                      doseLabel: _dose.text.trim(),
                    );
                    if (!mounted) return;
                    goToPage(context, AppPage.vaccinationDashboard, replace: true);
                  } catch (error) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(_friendlySupabaseMessage(error))));
                  } finally {
                    if (mounted) setState(() => _saving = false);
                  }
                },
          child: Column(
            children: [
              if (pets.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _petId,
                  decoration: const InputDecoration(labelText: 'Pet'),
                  items: pets
                      .map(
                        (pet) => DropdownMenuItem<String>(
                          value: pet['id']?.toString(),
                          child: Text(pet['name']?.toString() ?? 'Pet'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _petId = value),
                ),
              const SizedBox(height: 12),
              _ResidentField(controller: _vaccine, label: 'Vaccine Name'),
              const SizedBox(height: 12),
              _ResidentField(controller: _dose, label: 'Dose Label'),
            ],
          ),
        );
      },
    );
  }
}

class PetMeetupsScreen extends StatelessWidget {
  const PetMeetupsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _PetListScaffold(
      title: 'Pet Meetups & Play Areas',
      loadRows: repository.fetchPetMeetups,
      onAdd: () => goToPage(context, AppPage.createPetMeetup),
      emptyLabel: 'No pet meetups yet.',
      mapTitle: (row) => row['title']?.toString() ?? 'Meetup',
      mapSubtitle: (row) =>
          '${_calendarDateLabel(row['meetup_date'])} • ${row['location_label'] ?? '-'}',
    );
  }
}

class CreatePetMeetupScreen extends StatefulWidget {
  const CreatePetMeetupScreen({super.key});
  @override
  State<CreatePetMeetupScreen> createState() => _CreatePetMeetupScreenState();
}

class _CreatePetMeetupScreenState extends State<CreatePetMeetupScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final _title = TextEditingController();
  final _summary = TextEditingController();
  final _location = TextEditingController();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return _PetFormScaffold(
      title: 'Create Pet Meetup',
      nextLabel: _saving ? 'Saving...' : 'Create',
      onNext: _saving
          ? null
          : () async {
              setState(() => _saving = true);
              try {
                await _repository.createPetMeetup(
                  title: _title.text.trim(),
                  summary: _summary.text.trim(),
                  meetupDate: DateTime.now().add(const Duration(days: 1)),
                  locationLabel: _location.text.trim(),
                );
                if (!mounted) return;
                goToPage(context, AppPage.petMeetups, replace: true);
              } catch (error) {
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(_friendlySupabaseMessage(error))));
              } finally {
                if (mounted) setState(() => _saving = false);
              }
            },
      child: Column(
        children: [
          _ResidentField(controller: _title, label: 'Meetup Title'),
          const SizedBox(height: 12),
          _ResidentField(controller: _summary, label: 'Summary', maxLines: 3),
          const SizedBox(height: 12),
          _ResidentField(controller: _location, label: 'Location'),
        ],
      ),
    );
  }
}

class CreatePetPostScreen extends StatefulWidget {
  const CreatePetPostScreen({super.key});
  @override
  State<CreatePetPostScreen> createState() => _CreatePetPostScreenState();
}

class _CreatePetPostScreenState extends State<CreatePetPostScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final _title = TextEditingController();
  final _body = TextEditingController();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return _PetFormScaffold(
      title: 'Create Pet Post',
      nextLabel: _saving ? 'Posting...' : 'Post',
      onNext: _saving
          ? null
          : () async {
              setState(() => _saving = true);
              try {
                await _repository.createPetSocialPost(
                  title: _title.text.trim(),
                  body: _body.text.trim(),
                );
                if (!mounted) return;
                goToPage(context, AppPage.petSocialFeed, replace: true);
              } catch (error) {
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(_friendlySupabaseMessage(error))));
              } finally {
                if (mounted) setState(() => _saving = false);
              }
            },
      child: Column(
        children: [
          _ResidentField(controller: _title, label: 'Post Title'),
          const SizedBox(height: 12),
          _ResidentField(controller: _body, label: 'Post Body', maxLines: 4),
        ],
      ),
    );
  }
}

class BookPetZoneScreen extends StatefulWidget {
  const BookPetZoneScreen({super.key});
  @override
  State<BookPetZoneScreen> createState() => _BookPetZoneScreenState();
}

class _BookPetZoneScreenState extends State<BookPetZoneScreen> {
  final AvenueRepository _repository = AvenueRepository();
  String? _petId;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _repository.fetchMyPets(),
      builder: (context, snapshot) {
        final pets = snapshot.data ?? const <Map<String, dynamic>>[];
        _petId ??= pets.isNotEmpty ? pets.first['id']?.toString() : null;
        return _PetFormScaffold(
          title: 'Book Pet Zone',
          nextLabel: _saving ? 'Booking...' : 'Confirm Booking',
          onNext: _saving || _petId == null
              ? null
              : () async {
                  setState(() => _saving = true);
                  try {
                    await _repository.bookPetZone(
                      petId: _petId!,
                      zoneName: 'East Play Zone',
                      bookingDate: DateTime.now().add(const Duration(days: 1)),
                      slotLabel: '07:00 - 08:00',
                    );
                    if (!mounted) return;
                    goToPage(context, AppPage.petHub, replace: true);
                  } catch (error) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(_friendlySupabaseMessage(error))));
                  } finally {
                    if (mounted) setState(() => _saving = false);
                  }
                },
          child: Column(
            children: [
              if (pets.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _petId,
                  decoration: const InputDecoration(labelText: 'Pet'),
                  items: pets
                      .map(
                        (pet) => DropdownMenuItem<String>(
                          value: pet['id']?.toString(),
                          child: Text(pet['name']?.toString() ?? 'Pet'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _petId = value),
                ),
              const SizedBox(height: 14),
              const _SimpleListCard(
                title: 'Zone',
                subtitle: 'East Play Zone • Tomorrow • 07:00 - 08:00',
              ),
            ],
          ),
        );
      },
    );
  }
}

class PetStoresScreen extends StatelessWidget {
  const PetStoresScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _PetListScaffold(
      title: 'Local Pet Stores',
      loadRows: repository.fetchPetStores,
      emptyLabel: 'No stores found.',
      mapTitle: (row) => row['store_name']?.toString() ?? 'Store',
      mapSubtitle: (row) =>
          '${row['category'] ?? 'General'} • ${row['location_label'] ?? '-'}',
    );
  }
}

class PetAdoptionCenterScreen extends StatelessWidget {
  const PetAdoptionCenterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _PetListScaffold(
      title: 'Pet Adoption Center',
      loadRows: repository.fetchPetAdoptionListings,
      emptyLabel: 'No adoption listings right now.',
      mapTitle: (row) => row['pet_name']?.toString() ?? 'Pet',
      mapSubtitle: (row) =>
          '${row['breed'] ?? row['species']} • ${row['age_label'] ?? '-'} • ${row['location_label'] ?? '-'}',
    );
  }
}

class VetDirectoryScreen extends StatelessWidget {
  const VetDirectoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _PetListScaffold(
      title: 'Vet Directory',
      loadRows: repository.fetchPetVets,
      emptyLabel: 'No vets listed right now.',
      mapTitle: (row) => row['full_name']?.toString() ?? 'Vet',
      mapSubtitle: (row) =>
          '${row['specialty'] ?? 'General'} • ${row['location_label'] ?? '-'}',
    );
  }
}

class _PetListScaffold extends StatelessWidget {
  const _PetListScaffold({
    required this.title,
    required this.loadRows,
    required this.emptyLabel,
    required this.mapTitle,
    required this.mapSubtitle,
    this.onAdd,
  });

  final String title;
  final Future<List<Map<String, dynamic>>> Function() loadRows;
  final String emptyLabel;
  final String Function(Map<String, dynamic>) mapTitle;
  final String Function(Map<String, dynamic>) mapSubtitle;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: title,
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goToPage(context, AppPage.petHub, replace: true),
          size: 40,
        ),
        actions: onAdd == null
            ? const <Widget>[]
            : [
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded),
                  color: AvenueColors.primary,
                ),
              ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadRows(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return _ResidentScrollView(
            child: rows.isEmpty
                ? _DataPlaceholderCard(label: emptyLabel)
                : Column(
                    children: rows
                        .map(
                          (row) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SimpleListCard(
                              title: mapTitle(row),
                              subtitle: mapSubtitle(row),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          );
        },
      ),
    );
  }
}

class _PetFormScaffold extends StatelessWidget {
  const _PetFormScaffold({
    required this.title,
    required this.child,
    required this.onNext,
    this.nextLabel = 'Next',
  });
  final String title;
  final Widget child;
  final VoidCallback? onNext;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: title,
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
          size: 40,
        ),
      ),
      body: _ResidentScrollView(
        child: Column(
          children: [
            child,
            const SizedBox(height: 18),
            AvenuePrimaryButton(
              label: nextLabel,
              onPressed: onNext ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidentField extends StatelessWidget {
  const _ResidentField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });
  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _HubHeroCard extends StatelessWidget {
  const _HubHeroCard({
    required this.totalPets,
    required this.dueVaccinations,
    required this.upcomingBookings,
  });
  final int totalPets;
  final int dueVaccinations;
  final int upcomingBookings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _Metric(title: 'Pets', value: '$totalPets'),
          _Metric(title: 'Due Soon', value: '$dueVaccinations'),
          _Metric(title: 'Bookings', value: '$upcomingBookings'),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AvenueColors.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AvenueColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AvenueColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _HubActionChip extends StatelessWidget {
  const _HubActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AvenueColors.outline.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AvenueColors.primary),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _PetMiniCard extends StatelessWidget {
  const _PetMiniCard({required this.row, this.onTap});
  final Map<String, dynamic> row;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _SimpleListCard(
      onTap: onTap,
      title: row['name']?.toString() ?? 'Pet',
      subtitle:
          '${row['species'] ?? '-'} • ${row['breed'] ?? '-'}\n${row['allergies'] ?? 'No allergies'}',
      trailing: row['gender']?.toString().toUpperCase() ?? '',
    );
  }
}

class _SimpleListCard extends StatelessWidget {
  const _SimpleListCard({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AvenueColors.outline.withValues(alpha: 0.22)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AvenueColors.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null && trailing!.isNotEmpty)
              Text(
                trailing!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AvenueColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}

class _PetDraftStore {
  static String name = '';
  static String species = 'dog';
  static String breed = '';
  static String gender = '';
  static String weightKgText = '';
  static String allergies = '';
  static String photoUrl = '';
  static String bio = '';

  static void clear() {
    name = '';
    species = 'dog';
    breed = '';
    gender = '';
    weightKgText = '';
    allergies = '';
    photoUrl = '';
    bio = '';
  }
}
