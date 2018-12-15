with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

with Ada.Synchronous_Task_Control; use Ada.Synchronous_Task_Control;
with Ada.Real_Time; use Ada.Real_Time;

with ComienzoFin;
with esptask_gen;
with pertask_gen;

with mockup_control;


procedure main is
  pragma Time_Slice(0.0);

-- Shared Float --
   --Type Declaration-- Header
   protected type Shared_Float is
      function Get return Float;
      procedure Set (New_Value:Float);
      private
      Data: Float := 0.0;
   end Shared_Float;
   --Type Implementation-- Body
   protected body Shared_Float is
      function Get return Float is
      begin
         return Data;
      end Get;
      procedure Set(New_Value: Float) is
      begin
         Data:= New_Value;
      end Set;
   end Shared_Float;

   --Instantiate Shared Floats--
   Temperature: Shared_Float;
   Reference: Shared_Float;

-- Task Procedures --
ReachRefEvent: aliased Suspension_Object;

   prev_control_signal: Float:=0.0;
   prev_error: Float:= 0.0;
   procedure ControlAlgo is
   error: Float;
   control_signal: Float;
   begin
      error := Reference.Get - Temperature.Get;
      --Put("Error: ");
      --Put(error);
      --Put(Reference.Get);
      --Put(Temperature.Get);
      --Put_Line("");
      control_signal := prev_control_signal + 17.5*error-15.88*prev_error;
      mockup_control.Heat(control_signal);
      prev_error := error;
      prev_control_signal := control_signal;
      if error < Reference.Get*0.1 then
         Set_True(ReachRefEvent);
      end if;
   end ControlAlgo;

   procedure ReadTemp is
   begin
     Temperature.Set(mockup_control.read_temp);
   end ReadTemp;

   procedure IncreaseRef is
   aux_value: Float;
   begin
      aux_value := Reference.Get;
      Reference.Set(aux_value + 2.0);
      Put("New Reference: ");
      Put(Reference.Get);
      Put_Line("");
   end IncreaseRef;

   procedure DecreaseRef is
   aux_value: Float;
   begin
      aux_value := Reference.Get;
      Reference.Set(aux_value - 2.0);
      Put("New Reference: ");
      Put(Reference.Get);
      Put_Line("");
   end DecreaseRef;

   prev_time: Time:= Clock;
   procedure ShowTemp is
   aux_time: Duration;
   begin
      Put("Reference Reached => Temperature: ");
      Put(Temperature.Get);
      Put("  Reference: ");
      Put(Reference.Get);
      Put_Line("");
      aux_time := To_Duration(Clock - prev_time);
      Put("Time: ");
      Put_Line(Duration'Image(aux_time));
      prev_time := Clock;
   end ShowTemp;

-- Tasks --
   T_Control: pertask_gen.Periodic_Task(1,55,2,500,ControlAlgo'Access);
   T_ReadTemp: pertask_gen.Periodic_Task(2, 50, 2, 2000, ReadTemp'Access);
   IncreaseRefEvent: aliased Suspension_Object;
   T_IncreaseRef: esptask_gen.Esporadic_Task(3, 45, 2,500, IncreaseRef'Access,IncreaseRefEvent'Access);
   DecreaseRefEvent: aliased Suspension_Object;
   T_DecreaseRef: esptask_gen.Esporadic_Task(4, 40, 2,500, DecreaseRef'Access,DecreaseRefEvent'Access);
   T_ReachRef: esptask_gen.Esporadic_Task(5, 35, 5, 500, ShowTemp'Access,ReachRefEvent'Access);

-- Anonymus Task for Keyboard --
   -- Declaration --
   task T_KeyboardAttention is
      pragma Priority(30);
   end T_KeyBoardAttention;
   -- Implementation --
   task body T_KeyboardAttention is
      cKeyPress: Character;
   begin
      loop
         Get(cKeyPress);
         if cKeyPress = 'i' then
            Set_True(IncreaseRefEvent);
         elsif cKeyPress = 'd' then
            Set_True(DecreaseRefEvent);
         elsif cKeyPress = 'f' then
            ComienzoFin.Fin.Set_Finish;
            -- Allow Sporadic Task To continue to exit
            Set_True(DecreaseRefEvent);
            Set_True(IncreaseRefEvent);
            Set_True(ReachRefEvent);
         end if;
         exit when ComienzoFin.Fin.Get_Finish;
      end loop;
      Put_Line("Finish Keyboard Attention");
   end T_KeyboardAttention;

begin
   Put_Line("All Tasks Active");
   Reference.Set(35.0);
   ComienzoFin.Comienzo.Set_Initial_Time(Clock+Seconds(3));
   delay until clock + seconds(1);
   ComienzoFin.Stop.Go;
   Put_Line("Finish Parent");
end main;
