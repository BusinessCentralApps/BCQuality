codeunit 50100 "Paris Naming Example"
{
    procedure HasCustomers(): Boolean
    var
        CroissantCustomer: Record Customer;
    begin
        exit(not CroissantCustomer.IsEmpty());
    end;
}
