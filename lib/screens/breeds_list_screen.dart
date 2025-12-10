import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cat_provider.dart';
import '../widgets/breed_list_item.dart';
import '../widgets/error_dialog.dart';
import 'breed_details_screen.dart';

class BreedsListScreen extends StatefulWidget {
  const BreedsListScreen({super.key});

  @override
  State<BreedsListScreen> createState() => _BreedsListScreenState();
}

class _BreedsListScreenState extends State<BreedsListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Породы котиков'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск породы...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: Consumer<CatProvider>(
        builder: (context, provider, child) {
          // Обработка ошибок
          if (provider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ErrorDialog.show(
                context,
                message: provider.errorMessage!,
                onRetry: provider.retry,
              );
              provider.clearError();
            });
          }

          // Состояние загрузки
          if (provider.breedsLoadingState == LoadingState.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Загружаем породы...'),
                ],
              ),
            );
          }

          // Состояние ошибки
          if (provider.breedsLoadingState == LoadingState.error) {
            return ErrorView(
              message: provider.errorMessage ?? 'Неизвестная ошибка',
              onRetry: provider.retry,
            );
          }

          // Фильтрация пород по поисковому запросу
          final breeds = _searchQuery.isEmpty
              ? provider.breeds
              : provider.breeds.where((breed) {
                  return breed.name.toLowerCase().contains(_searchQuery) ||
                      (breed.origin?.toLowerCase().contains(_searchQuery) ??
                          false) ||
                      (breed.temperament?.toLowerCase().contains(
                            _searchQuery,
                          ) ??
                          false);
                }).toList();

          // Пустой список
          if (breeds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'Породы не найдены'
                        : 'Нет результатов по запросу "$_searchQuery"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: breeds.length,
            itemBuilder: (context, index) {
              final breed = breeds[index];
              return BreedListItem(
                breed: breed,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BreedDetailsScreen(breed: breed),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
