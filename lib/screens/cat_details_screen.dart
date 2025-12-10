import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_image.dart';

class CatDetailsScreen extends StatelessWidget {
  final CatImage cat;

  const CatDetailsScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final breed = cat.primaryBreed;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                breed?.name ?? 'Котик',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: cat.id,
                child: CachedNetworkImage(
                  imageUrl: cat.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error, size: 50)),
                ),
              ),
            ),
          ),
          if (breed != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Основная информация
                    _buildInfoCard(
                      context,
                      icon: Icons.info_outline,
                      title: 'Основная информация',
                      children: [
                        if (breed.origin != null)
                          _buildInfoRow(
                            context,
                            icon: Icons.location_on,
                            label: 'Происхождение',
                            value: breed.origin!,
                          ),
                        if (breed.lifeSpan != null)
                          _buildInfoRow(
                            context,
                            icon: Icons.calendar_today,
                            label: 'Продолжительность жизни',
                            value: '${breed.lifeSpan} лет',
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Описание
                    if (breed.description != null)
                      _buildInfoCard(
                        context,
                        icon: Icons.description,
                        title: 'Описание',
                        children: [
                          Text(
                            breed.description!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    // Темперамент
                    if (breed.temperament != null)
                      _buildInfoCard(
                        context,
                        icon: Icons.psychology,
                        title: 'Темперамент',
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: breed.temperament!
                                .split(',')
                                .map(
                                  (trait) => Chip(
                                    label: Text(trait.trim()),
                                    backgroundColor: Colors.pink.shade50,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    // Характеристики
                    _buildInfoCard(
                      context,
                      icon: Icons.bar_chart,
                      title: 'Характеристики',
                      children: [
                        if (breed.adaptability != null)
                          _buildCharacteristic(
                            context,
                            label: 'Адаптивность',
                            value: breed.adaptability!,
                          ),
                        if (breed.affectionLevel != null)
                          _buildCharacteristic(
                            context,
                            label: 'Уровень привязанности',
                            value: breed.affectionLevel!,
                          ),
                        if (breed.childFriendly != null)
                          _buildCharacteristic(
                            context,
                            label: 'Дружелюбность к детям',
                            value: breed.childFriendly!,
                          ),
                        if (breed.energyLevel != null)
                          _buildCharacteristic(
                            context,
                            label: 'Уровень энергии',
                            value: breed.energyLevel!,
                          ),
                      ],
                    ),

                    // Ссылка на Wikipedia
                    if (breed.wikipediaUrl != null) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Открыть ссылку (требует url_launcher)
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Читать в Wikipedia'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacteristic(
    BuildContext context, {
    required String label,
    required int value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: value / 5,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.pink,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text('$value/5', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
