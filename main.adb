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

   protected type Shared_Char is
      function Get return Character;
      procedure Set (New_Value:Character);
      private
      Data: Character;
   end Shared_Char;
   --Type Implementation-- Body
   protected body Shared_Char is
      function Get return Character is
      begin
         return Data;
      end Get;
      procedure Set(New_Value: Character) is
      begin
         Data:= New_Value;
      end Set;
   end Shared_Char;

   protected type Shared_Time is
      function Get return Time;
      procedure Set (New_Value:Time);
      private
      Data: Time;
   end Shared_Time;
   --Type Implementation-- Body
   protected body Shared_Time is
      function Get return Time is
      begin
         return Data;
      end Get;
      procedure Set(New_Value: Time) is
      begin
         Data:= New_Value;
      end Set;
   end Shared_Time;

   --Instantiate Shared Floats/Shared Char (protected objects)--
   Temperature: Shared_Float;
   Reference: Shared_Float;
   FlagRefReach: Shared_Float;
   cKeyPress: Shared_Char;
   Prot_Clock: Shared_Time;


   --Semaphores--
   ReachRefEvent: aliased Suspension_Object;
   ChangeRefEvent: aliased Suspension_Object;

-- Task Procedures --
   prev_control_signal: Float:=0.0;
   prev_error: Float:= 0.0;
   	    --Estas dos variables se encuentran declaradas como globales para
   	    --que cada vez que se llame a la tarea periodica no se reinicialicen
   procedure ControlAlgo is
      error: Float;
      control_signal: Float;
   begin
      error := Reference.Get - Temperature.Get;
      control_signal := prev_control_signal + 17.5*error-15.88*prev_error;
      mockup_control.Heat(control_signal);
      prev_error := error;
      prev_control_signal := control_signal;
      if error < Reference.Get*0.05 then
         if FlagRefReach.Get = 0.0 then
            Set_True(ReachRefEvent);
            FlagRefReach.Set(1.0);
      	 end if;
      end if;
   end ControlAlgo;

   procedure ReadTemp is
   begin
     Temperature.Set(mockup_control.read_temp);
   end ReadTemp;

   --prev_time: Time:= Clock;
   procedure ChangeRef is
   begin
      FlagRefReach.Set(0.0);
      if cKeyPress.Get = 'i' then
         Reference.Set(Reference.Get + 2.0);
         Prot_Clock.Set(Clock);
      elsif cKeyPress.Get = 'd' then
         Reference.Set(Reference.Get - 2.0);
         Prot_Clock.Set(Clock);
      end if;

      Put("New Reference: ");Put(Reference.Get);Put_Line("");
   end ChangeRef;

   procedure ShowTemp is
   aux_time: Duration;
   begin
      Put("Reference Reached => Temperature: ");
      Put(Temperature.Get);
      Put("  Reference: ");
      Put(Reference.Get);
      Put_Line("");
      aux_time := To_Duration(Clock - Prot_Clock.Get);
      Put("Time: ");
      Put_Line(Duration'Image(aux_time));
   end ShowTemp;

-- Tasks --
   T_Control: pertask_gen.Periodic_Task(1,30,2,500,ControlAlgo'Access);
   T_ReachRef: esptask_gen.Esporadic_Task(3, 25, 5, 500, ShowTemp'Access,ReachRefEvent'Access);
   T_ReadTemp: pertask_gen.Periodic_Task(2, 20, 2, 2000, ReadTemp'Access);
   T_ChangeRef: esptask_gen.Esporadic_Task(4, 15, 10, 10000, ChangeRef'Access,ChangeRefEvent'Access);

   -- Anonymus Task for Keyboard --

   -- Declaration --
   task T_KeyboardAttention is
      pragma Priority(10);
   end T_KeyBoardAttention;
   -- Implementation --
   task body T_KeyboardAttention is
      cKeyPress_aux:character;
   begin
      loop
         Get(cKeyPress_aux);
         cKeyPress.Set(cKeyPress_aux);
         if cKeyPress.Get = 'i' then
            Set_True(ChangeRefEvent);
	 elsif cKeyPress.Get = 'd' then
            Set_True(ChangeRefEvent);
         elsif cKeyPress.Get = 'f' then
            ComienzoFin.Fin.Set_Finish;
            -- Allow Sporadic Task To continue to exit
            Set_True(ReachRefEvent);
            Set_True(ChangeRefEvent);
         end if;
         exit when ComienzoFin.Fin.Get_Finish;
      end loop;
      Put_Line("Finish Keyboard Attention");
   end T_KeyboardAttention;

begin
   FlagRefReach.Set(0.0);
   Reference.Set(35.0);
   Prot_Clock.Set(Clock);
   ComienzoFin.Comienzo.Set_Initial_Time(Clock+Seconds(3));
   delay until clock + seconds(1);
   ComienzoFin.Stop.Go;
   Put_Line("All Tasks Active");
end main;
