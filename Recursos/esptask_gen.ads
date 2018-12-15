with Ada.Synchronous_Task_Control; use Ada.Synchronous_Task_Control;
with Ada.Real_Time;use Ada.Real_Time; -- Clock, seconds

package esptask_gen is

 ------tipo TAREA----------------
   task type Esporadic_Task (Id, Prio, Separation, Plazo : Integer; Proc: not null access Procedure; Control: not null access Suspension_Object) is
      pragma Priority(Prio);
   end Esporadic_Task;

end esptask_gen;
