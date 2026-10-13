// Demonstration only. Shows the wrong pattern: exported text uses the default MSDos stream encoding.

codeunit 50190 "Customer CSV Export Bad"
{
    procedure ExportCustomers()
    var
        Customer: Record Customer;
        ExportBuffer: Record "Export Buffer Demo" temporary;
        CsvOutStream: OutStream;
        CsvInStream: InStream;
        FileName: Text;
    begin
        // BAD: no TextEncoding, so the stream uses MSDos. Names such as "Müller" or "Łódź"
        // arrive corrupted in the downloaded file.
        ExportBuffer.Content.CreateOutStream(CsvOutStream);
        if Customer.FindSet() then
            repeat
                CsvOutStream.WriteText(Customer."No." + ';' + Customer.Name);
                CsvOutStream.WriteText();
            until Customer.Next() = 0;

        ExportBuffer.Content.CreateInStream(CsvInStream);
        FileName := 'customers.csv';
        DownloadFromStream(CsvInStream, '', '', '', FileName);
    end;
}
