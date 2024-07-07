report 50006 "Item Stock Aging"
{
    ApplicationArea = All;
    Caption = 'Item Stock Aging';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Item Stock Aging.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") where(Type = const(Inventory));
            RequestFilterFields = "No.", "Date Filter";


            column(No; "No.")
            {
            }
            column(BaseUnitofMeasure; "Base Unit of Measure")
            {
            }
            column(Inventory; Inventory)
            {
            }
            column(InventoryPostingGroup; "Inventory Posting Group")
            {
            }
            column(Description; Description)
            {
            }
            column(Type; "Type")
            {
            }
            column(NextCountingStartDate; "Next Counting Start Date")
            {
            }
            column(NextCountingEndDate; "Next Counting End Date")
            {
            }
            column(CompanyName; CompanyName)
            {

            }

            column(PeriodLength; PeriodLength)
            {

            }
            column(As_of_date; EndingDate)
            {

            }
            column(PeriodStartDate1; PeriodStartDate[1])
            {

            }
            column(PeriodStartDate2; PeriodStartDate[2])
            {

            }
            column(PeriodStartDate3; PeriodStartDate[3])
            {

            }
            column(PeriodStartDate4; PeriodStartDate[4])
            {

            }
            column(PeriodEndDate1; PeriodEndDate[1])
            {

            }
            column(PeriodEndDate2; PeriodEndDate[2])
            {

            }
            column(PeriodEndDate3; PeriodEndDate[3])
            {

            }
            column(PeriodEndDate4; PeriodEndDate[4])
            {

            }
            column(TillDate; TillDate)
            {

            }
            column(InventoryQty_ItemLedgeEntry1; InventoryQty[1])
            {
                DecimalPlaces = 0 : 2;
            }
            column(InventoryQty2_ItemLedgeEntry; InventoryQty[2])
            {
                DecimalPlaces = 0 : 2;
            }
            column(InventoryQty3_ItemLedgeEntry; InventoryQty[3])
            {
                DecimalPlaces = 0 : 2;
            }
            column(InventoryQty4_ItemLedgeEntry; InventoryQty[4])
            {
                DecimalPlaces = 0 : 2;
            }
            column(Inventory1; Inventory)
            {

            }


            trigger OnAfterGetRecord()
            var

                Itemledgerentries: Record "Item Ledger Entry";
                PeriodStartDate1: array[4] of Date;
                PeriodEndDate2: array[4] of Date;
                DateFilter: Date;
                i: Integer;


            begin

                for i := 1 to 4 do begin
                    InventoryQty[i] := 0
                end;

                Itemledgerentries.Reset();
                Itemledgerentries.SetCurrentKey("Item No.", "Posting Date");
                Itemledgerentries.SetRange("Item No.", "No.");
                for i := 1 to 3 do begin
                    Itemledgerentries.SetRange("Posting Date", PeriodStartDate[i], PeriodEndDate[i]);
                    if Itemledgerentries.FindSet() then
                        repeat
                            InventoryQty[i] := InventoryQty[i] + Itemledgerentries."Quantity";
                        until Itemledgerentries.Next() = 0;
                end;
                Itemledgerentries.SetFilter("Posting Date", '..%1', TillDate);
                if Itemledgerentries.Findset() then
                    repeat

                        InventoryQty[4] := InventoryQty[4] + Itemledgerentries."Quantity";
                    until Itemledgerentries.Next() = 0;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(As_of_date; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the aging calculated for.';

                    }
                    field(PeriodLength; PeriodLength)
                    {

                    }
                    field(DateFilter; DateFilter)
                    {

                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnPreReport()
    var
        Msg: Label 'Today is ''%1''\Start Date of the month is ''%2''\ End Date of the month is ''%3''\Start Date2 of the month is ''%4''\End date2 of the month is ''%5''\Start Date3 of the  month is ''%6''\End Date of the month is ''%7''\Till date of the month is ''%8''';

    begin
        if CompanyInfo.get() then begin
            CompanyInfo.CalcFields(Picture);
            CompanyName := CompanyInfo.Name;
        end;

        PeriodStartDate[1] := CalcDate('<-CM>', Today);
        PeriodEndDate[1] := CalcDate('<CM>', Today);
        PeriodStartDate[2] := CalcDate('<-CM>', PeriodStartDate[1] - 1);
        PeriodEndDate[2] := CalcDate('<CM>', PeriodStartDate[1] - 2);
        PeriodStartDate[3] := CalcDate('-<CM>', PeriodStartDate[2] - 1);
        PeriodEndDate[3] := CalcDate('<CM>', PeriodStartDate[2] - 1);
        TillDate := CalcDate('<CM>', PeriodStartDate[3] - 1);

        Message(Msg, Today, PeriodStartDate[1], PeriodEndDate[1], PeriodStartDate[2], PeriodEndDate[2], PeriodStartDate[3], PeriodEndDate[3], TillDate);

    end;


    var
        CompanyInfo: Record "Company Information";
        CompanyName: text[100];
        PeriodLength: DateFormula;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodStartDate: array[4] of Date;
        PeriodEndDate: array[4] of Date;
        TillDate: Date;
        InventoryQty: array[4] of Decimal;
        TotalInventoryQty: Decimal;
        DateFilter: Date;
        Inventory: Decimal;
        i: Integer;

}
