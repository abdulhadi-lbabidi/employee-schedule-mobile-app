part of 'loan_bloc.dart';

 class LoanState {
  final DataStateModel<List<Loane>?> getAllLoansData;
  final DataStateModel<GetAllLoansResponse?> getEmployeeAllLoansData;

  const LoanState({
    this.getAllLoansData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.getEmployeeAllLoansData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
  });

  LoanState copyWith({
    DataStateModel<List<Loane>?>? getAllLoansData,
    DataStateModel<GetAllLoansResponse?>? getEmployeeAllLoansData,
  }) {
    return LoanState(
      getAllLoansData: getAllLoansData ?? this.getAllLoansData,
      getEmployeeAllLoansData:
          getEmployeeAllLoansData ?? this.getEmployeeAllLoansData,
    );
  }
}
