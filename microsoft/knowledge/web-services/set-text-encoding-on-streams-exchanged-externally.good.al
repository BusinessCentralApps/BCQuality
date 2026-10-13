// Demonstration only. Shows the recommended pattern: exported text uses an explicit UTF-8 encoding on both streams.

codeunit 50191 "Customer CSV Export Good"
{
    procedure ExportCustomers()
    var
        Customer: Record Customer;
        ExportBuffer: Record "Export Buffer Demo" temporary;
        CsvOutStream: OutStream;
        CsvInStream: InStream;
        FileName: Text;
    begin
        ExportBuffer.Content.CreateOutStream(CsvOutStream, TextEncoding::UTF8);
        if Customer.FindSet() then
            repeat
                CsvOutStream.WriteText(Customer."No." + ';' + Customer.Name);
                CsvOutStream.WriteText();
            until Customer.Next() = 0;

        ExportBuffer.Content.CreateInStream(CsvInStream, TextEncoding::UTF8);
        FileName := 'customers.csv';
        DownloadFromStream(CsvInStream, '', '', '', FileName);
    end;
}
