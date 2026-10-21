codeunit 50100 "Paris Naming Example"
{
    procedure HasCustomers(): Boolean
    var
        Customer: Record Customer;
    begin
        exit(not Customer.IsEmpty());
    end;
}
