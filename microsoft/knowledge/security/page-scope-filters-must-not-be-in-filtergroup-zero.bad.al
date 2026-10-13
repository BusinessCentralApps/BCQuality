// Demonstration only. Shows the wrong pattern: a page restricts its records with a filter the user can remove.

page 50184 "My Expense Claims Bad"
{
    PageType = List;
    SourceTable = "Expense Claim Demo";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Claims)
            {
                field("No."; Rec."No.") { }
                field("Employee User ID"; Rec."Employee User ID") { }
                field(Amount; Rec.Amount) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // BAD: no FilterGroup call, so this filter is in group 0. The user can clear it in the
        // filter pane and see every employee's claims.
        Rec.SetRange("Employee User ID", UserId());
    end;
}
