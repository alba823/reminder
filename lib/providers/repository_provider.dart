import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/data/database/event_dao.dart';
import 'package:reminder/data/repo/repository.dart';
import 'package:reminder/providers/blocs_provider.dart';

class RepositoryProviderWidget extends StatelessWidget {
  const RepositoryProviderWidget({super.key, required this.eventDao});

  final EventDao eventDao;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<Repository>(
        create: (_) => RepositoryImpl(eventDao),
        child: const BlocsProviderWidget());
  }
}