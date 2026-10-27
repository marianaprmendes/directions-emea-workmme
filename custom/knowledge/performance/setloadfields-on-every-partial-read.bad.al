codeunit 50190 "Equipment Read Bad"
{
    // Equipment has fewer than ten fields today, so SetLoadFields was skipped.
    procedure GetEquipmentDescription(EquipmentNo: Code[20]): Text[100]
    var
        Equipment: Record Equipment;
    begin
        if Equipment.Get(EquipmentNo) then
            exit(Equipment.Description);
    end;

    procedure GetAvailableDescriptions(): List of [Text]
    var
        Equipment: Record Equipment;
        Descriptions: List of [Text];
    begin
        Equipment.SetRange(Blocked, false);
        if Equipment.FindSet() then
            repeat
                Descriptions.Add(Equipment.Description);
            until Equipment.Next() = 0;
        exit(Descriptions);
    end;
}
