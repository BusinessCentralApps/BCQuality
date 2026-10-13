// Demonstration only. Shows the wrong pattern: a BLOB field is read without being calculated.

codeunit 50188 "Payload Reader Bad"
{
    procedure GetPayload(EntryNo: Integer): Text
    var
        IntegrationLog: Record "Integration Log Demo";
        PayloadInStream: InStream;
        PayloadText: Text;
    begin
        IntegrationLog.Get(EntryNo);
        // BAD: Get does not load BLOB content. The stream is empty and PayloadText stays ''.
        IntegrationLog.Payload.CreateInStream(PayloadInStream, TextEncoding::UTF8);
        PayloadInStream.ReadText(PayloadText);
        exit(PayloadText);
    end;
}
