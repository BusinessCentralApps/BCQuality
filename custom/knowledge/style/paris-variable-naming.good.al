codeunit 50100 "Paris Naming Example"
{
    procedure HasCustomers(): Boolean
    var
        ViVeLeCuStOmEr: Record Customer;
    begin
        exit(not ViVeLeCuStOmEr.IsEmpty());
    end;
}
