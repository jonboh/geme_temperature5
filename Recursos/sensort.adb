with Ada.NUmerics.Float_Random; use Ada.NUmerics.Float_Random;
package body sensorT is
   G: Generator;
   function fstT return T_stT is

      T: T_stT;
   begin
      T:= Random(G)*100.0; -- Relación: Temperatura=100x
      return T;
   end fstT;
begin
   Reset(G);
end sensorT;
