with Ada.Real_Time;use Ada.Real_Time;
with Ada.Text_Io; use Ada.Text_Io;
with ComienzoFin; use ComienzoFin;
package body PerTask_gen is

   task body Periodic_Task is
      Per,D  : Time_Span;
      Next : Time;
   begin
      Put_Line("Ejecuto tarea peri�dica" & Integer'Image (Id));

      Stop.Wait;
      Per  := Seconds(Period);-- precisi�n unidad  de tiempo
      D:= milliSeconds(Deadline);
      Next:= Comienzo.Get_Initial_Time; -- planificadas respecto a initial_time
      delay until Next;

      loop
         select
            delay until (Next + D); -- delay hasta hora actual + plazo: entiende mezclas de unidades
            pUT ("ABORTO"& Integer'Image(Id));-- aqu� podr�a ir la recovery acci�n
         then abort
            --  Procedimiento que se ejecuta peri�dicamente;
             Proc.all;-- aborto si me paso el plazo
         end select;
         Next := Next + Per;
         delay until Next;
         exit when Fin.Get_Finish;
      end loop;
      Put_Line ("Fin tarea" & Integer'Image(Id));
   end Periodic_Task;
end PerTask_gen;
