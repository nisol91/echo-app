import 'package:get_it/get_it.dart';
import './services/api_crud.dart';
import './viewmodels/crud_model_corporate.dart';

//QUESTO FILE LOCALIZZA I MODEL DELLE CRUD
GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => Api('corporates'));
  locator.registerLazySingleton(() => CrudModel());
}
