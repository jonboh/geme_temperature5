with Ada.Real_Time;use Ada.Real_Time;
with barreras; use barreras;

package ComienzoFin is

   Stop: Barrier;

   protected Comienzo is
      procedure Set_Initial_Time(It : Time);
      function Get_Initial_Time return Time;
   private
      Initial_Time : Time;
   end Comienzo;

   protected Fin is
      procedure Set_Finish;
      function Get_Finish return Boolean;
   private
      Finished : Boolean := False;
   end Fin;
end ComienzoFin;
