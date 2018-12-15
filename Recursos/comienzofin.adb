package body ComienzoFin is
   protected body Comienzo is
      procedure Set_Initial_Time(It : Time) is
      begin
         Initial_Time := It;
      end Set_Initial_Time;

      function Get_Initial_Time return Time is
      begin
         return Initial_Time;
      end Get_Initial_Time;
   end Comienzo;


   protected body Fin is
      procedure Set_Finish is
      begin
         Finished := True;
      end Set_Finish;

      function Get_Finish return Boolean is
      begin
         return Finished;
      end Get_FInish;
   end Fin;
end ComienzoFin;


