part of 'loan_bloc.dart';

 class LoanState {
  final DataStateModel<GetAllLoansResponse?> getAllLoansData;
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
    DataStateModel<GetAllLoansResponse?>? getAllLoansData,
    DataStateModel<GetAllLoansResponse?>? getEmployeeAllLoansData,
  }) {
    return LoanState(
      getAllLoansData: getAllLoansData ?? this.getAllLoansData,
      getEmployeeAllLoansData:
          getEmployeeAllLoansData ?? this.getEmployeeAllLoansData,
    );
  }
}
