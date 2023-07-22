import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/data/local_storage/local_storage_service.dart';
import 'package:reminder/data/models/event_dao.dart';
import 'package:reminder/data/repository/repository.dart';
import 'package:reminder/ui/providers/providers.dart';

class RepositoryProviderWidget extends StatelessWidget {
  const RepositoryProviderWidget({super.key, required this.eventDao});

  final EventDao eventDao;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Repository>(
          create: (_) => RepositoryImpl(eventDao),
        ),
        RepositoryProvider<LocalStorageService>(
          create: (_) => LocalStorageServiceImpl(),
        ),
      ],
      child: const BlocsProviderWidget(),
    );
  }
}
