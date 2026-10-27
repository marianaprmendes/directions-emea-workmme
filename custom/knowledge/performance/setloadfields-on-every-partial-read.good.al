codeunit 50191 "Equipment Read Good"
{
    // Load only the fields the code reads, even on a small table.
    procedure GetEquipmentDescription(EquipmentNo: Code[20]): Text[100]
    var
        Equipment: Record Equipment;
    begin
        Equipment.SetLoadFields(Description);
        if Equipment.Get(EquipmentNo) then
            exit(Equipment.Description);
    end;

    procedure GetAvailableDescriptions(): List of [Text]
    var
        Equipment: Record Equipment;
        Descriptions: List of [Text];
    begin
        Equipment.SetRange(Blocked, false);
        Equipment.SetLoadFields(Description);
        if Equipment.FindSet() then
            repeat
                Descriptions.Add(Equipment.Description);
            until Equipment.Next() = 0;
        exit(Descriptions);
    end;
}
