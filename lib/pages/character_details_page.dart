import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/services/tmb_services.dart';

class CharacterDetailScreen extends StatefulWidget {
  final int characterId;

  const CharacterDetailScreen({super.key, required this.characterId});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  final RickAndMortyApiService _apiService = RickAndMortyApiService();
  Character? _character;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCharacterDetails();
  }

  /// Fetches detailed information for the character.
  Future<void> _fetchCharacterDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final character = await _apiService.fetchCharacterById(widget.characterId);
      setState(() {
        _character = character;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load character details: $e';
        _isLoading = false;
      });
      print('Error fetching character details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_character?.name ?? 'Character Details'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Match main background
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _character == null
                  ? const Center(child: Text('Character not found.', style: TextStyle(color: Colors.white70)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700), // Max width for detail view
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Character Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                  _character!.image,
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 250,
                                      height: 250,
                                      color: Colors.grey[700],
                                      child: const Icon(Icons.person_off, color: Colors.white54, size: 100),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32.0),
                              // Character Name
                              Text(
                                _character!.name,
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20.0),
                              // Status, Species, Gender
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 16.0,
                                runSpacing: 12.0,
                                children: [
                                  _buildDetailChip(
                                    label: 'Status',
                                    value: _character!.status,
                                    color: _character!.status == 'Alive' ? Colors.green.shade700 : (_character!.status == 'Dead' ? Colors.red.shade700 : Colors.grey.shade700),
                                  ),
                                  _buildDetailChip(label: 'Species', value: _character!.species, color: Colors.blueGrey.shade700),
                                  _buildDetailChip(label: 'Gender', value: _character!.gender, color: Colors.purple.shade700),
                                ],
                              ),
                              const SizedBox(height: 32.0),
                              // Origin
                              _buildDetailRow(
                                icon: Icons.public,
                                label: 'Origin:',
                                value: _character!.origin.name,
                              ),
                              const SizedBox(height: 16.0),
                              // Last Known Location
                              _buildDetailRow(
                                icon: Icons.location_on,
                                label: 'Last Known Location:',
                                value: _character!.location.name,
                              ),
                              const SizedBox(height: 32.0),
                              // Episodes
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Episodes appeared in:',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: _character!.episode.map((e) {
                                    final episodeNumber = e.split('/').last; // Extract episode number from URL
                                    return Chip(
                                      label: Text('Episode $episodeNumber'),
                                      backgroundColor: Colors.blueGrey.shade600,
                                      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
    );
  }

  /// Helper widget to build a detail chip (e.g., Status, Species).
  Widget _buildDetailChip({required String label, required String value, required Color color}) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }

  /// Helper widget to build a detail row (e.g., Origin, Location).
  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(width: 12.0),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}