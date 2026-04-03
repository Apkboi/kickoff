import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../controllers/live_matches_bloc.dart';
import '../controllers/trending_leagues_bloc.dart';
import '../controllers/upcoming_matches_bloc.dart';
import '../widgets/home_loaded_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      getIt<LiveMatchesBloc>().add(const LiveMatchesStarted());
      getIt<UpcomingMatchesBloc>().add(const UpcomingMatchesStarted());
      getIt<TrendingLeaguesBloc>().add(const TrendingLeaguesStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LiveMatchesBloc>.value(value: getIt()),
        BlocProvider<UpcomingMatchesBloc>.value(value: getIt()),
        BlocProvider<TrendingLeaguesBloc>.value(value: getIt()),
      ],
      child: const HomeLoadedView(),
    );
  }
}
