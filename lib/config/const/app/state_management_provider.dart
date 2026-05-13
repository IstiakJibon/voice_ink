import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/config/theme/cubit/theme_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/authentication/authentication_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/registation/registation_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/re_transcribe/re_transcribe_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_cubit.dart';
import 'package:voice_ink/features/folder/presentation/cubit/folder_cubit.dart';
import 'package:voice_ink/features/quota/presentation/cubit/quota_cubit.dart';
import 'package:voice_ink/features/upload/presentation/cubit/upload_cubit.dart';
import 'package:voice_ink/features/podcast/presentation/cubit/podcast_cubit.dart';
import 'package:voice_ink/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:voice_ink/features/url_import/presentation/cubit/url_import_cubit.dart';

class StateManagementProviders {
  static List<SingleChildWidget> providers = [
    BlocProvider(create: (context) => sl<ThemeCubit>()),
    BlocProvider(create: (context) => sl<LoginCubit>()),
    BlocProvider(create: (context) => sl<AuthenticationCubit>()),
    BlocProvider(create: (context) => sl<RegistrationCubit>()),
    BlocProvider(create: (context) => sl<ForgotPasswordCubit>()),
    BlocProvider(create: (context) => sl<ResetPasswordCubit>()),
    BlocProvider(create: (context) => sl<FilesCubit>()),
    BlocProvider(create: (context) => sl<TranscriptDetailCubit>()),
    BlocProvider(create: (context) => sl<ReTranscribeCubit>()),
    BlocProvider(create: (context) => sl<QuotaCubit>()),
    BlocProvider(create: (context) => sl<FolderCubit>()),
    BlocProvider(create: (context) => sl<UploadCubit>()),
    BlocProvider(create: (context) => sl<UrlImportCubit>()),
    BlocProvider(create: (context) => sl<ScanCubit>()),
    BlocProvider(create: (context) => sl<PodcastCubit>()),
  ];
}