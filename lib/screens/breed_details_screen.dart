import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_breed.dart';
import '../providers/cat_provider.dart';

class BreedDetailsScreen extends StatefulWidget {
  final CatBreed breed;

  const BreedDetailsScreen({super.key, required this.breed});

  @override
  State<BreedDetailsScreen> createState() => _BreedDetailsScreenState();
}

class _BreedDetailsScreenState extends State<BreedDetailsScreen> {
  List<String> _images = [];
  bool _isLoadingImages = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final provider = context.read<CatProvider>();
    final images = await provider.getBreedImages(widget.breed.id);
    if (mounted) {
      setState(() {
        _images = images;
        _isLoadingImages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.breed.name), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Галерея изображений
            _buildImageGallery(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название и происхождение
                  Text(
                    widget.breed.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.breed.origin != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.breed.origin!,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Описание
                  if (widget.breed.description != null) ...[
                    _buildSectionTitle(context, 'Описание', Icons.description),
                    const SizedBox(height: 8),
                    Text(
                      widget.breed.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Характеристики
                  _buildSectionTitle(
                    context,
                    'Характеристики',
                    Icons.bar_chart,
                  ),
                  const SizedBox(height: 16),
                  _buildCharacteristicsGrid(),
                  const SizedBox(height: 24),

                  // Темперамент
                  if (widget.breed.temperament != null) ...[
                    _buildSectionTitle(
                      context,
                      'Темперамент',
                      Icons.psychology,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.breed.temperament!
                          .split(',')
                          .map(
                            (trait) => Chip(
                              label: Text(trait.trim()),
                              backgroundColor: Colors.pink.shade50,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Дополнительная информация
                  _buildSectionTitle(
                    context,
                    'Дополнительная информация',
                    Icons.info,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    if (_isLoadingImages) {
      return Container(
        height: 250,
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.pets, size: 64, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: _images[index],
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error, size: 50)),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.pink),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCharacteristicsGrid() {
    final characteristics = <Map<String, dynamic>>[
      if (widget.breed.adaptability != null)
        {
          'label': 'Адаптивность',
          'value': widget.breed.adaptability!,
          'icon': Icons.home,
        },
      if (widget.breed.affectionLevel != null)
        {
          'label': 'Привязанность',
          'value': widget.breed.affectionLevel!,
          'icon': Icons.favorite,
        },
      if (widget.breed.childFriendly != null)
        {
          'label': 'Дружелюбие к детям',
          'value': widget.breed.childFriendly!,
          'icon': Icons.child_care,
        },
      if (widget.breed.energyLevel != null)
        {
          'label': 'Энергичность',
          'value': widget.breed.energyLevel!,
          'icon': Icons.flash_on,
        },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: characteristics.length,
      itemBuilder: (context, index) {
        final char = characteristics[index];
        return _buildCharacteristicCard(
          label: char['label'] as String,
          value: char['value'] as int,
          icon: char['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildCharacteristicCard({
    required String label,
    required int value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.pink, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  index < value ? Icons.star : Icons.star_border,
                  size: 16,
                  color: Colors.amber,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.breed.lifeSpan != null)
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Продолжительность жизни',
                value: '${widget.breed.lifeSpan} лет',
              ),
            if (widget.breed.wikipediaUrl != null) ...[
              const Divider(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  // Открыть ссылку (требует url_launcher)
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Читать в Wikipedia'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
