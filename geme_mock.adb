with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;


package body geme_mock is

   initial_temp: constant Float := 21.0;
-- Shared Float --
   --Type Declaration-- Header
   protected type Shared_Float is
      function Get return Float;
      procedure Set (New_Value:Float);
      private
      Data: Float := initial_temp;
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

   Geme_Temperature: Shared_Float;

   prev_temp: Float:=initial_temp;
   prev_control_signal: Float:=0.0;
    procedure Write_ao_PCM3712(Volts: Float) is
    power: Float;
    aux_temp: Float;
    begin
        power := volts * gain_wats_volt;
        --Ada.Text_IO.Put("Heating with ");
        --Ada.Float_Text_IO.Put(Volts);
        aux_temp := 0.8825*prev_temp +0.01763*prev_control_signal;
	Geme_Temperature.Set(aux_temp);
        prev_temp := aux_temp;
        prev_control_signal := power;
    end Write_ao_PCM3712;

    function Adquirir return Float is
    temp: Float;
    temp_volt: Float;
    begin
        temp := Geme_Temperature.Get;
        --put("GemeTemperature: ");
        --put(temp);
        --put_line("");
        temp_volt := temp / gain_volt_temp;
        return temp_volt;-- random generator here
    end Adquirir;



    procedure Initialize_PCM3712 is
    begin
        Ada.Text_IO.Put_Line("Initializing PCM3712");
    end Initialize_PCM3712;

    procedure Configuracion_Inicial(Conexion: String; Canal_Primero: Integer; Canal_Ultimo: Integer; Disparo: String; Numero_Muestras: Integer; Rango: String) is
    begin
        put_line("PCM3718 MOCK configured");
    end Configuracion_Inicial;

    procedure Fin_Adquisicion is
    begin
        put_line("Connection with PCM3718 closed.");
    end Fin_Adquisicion;
end geme_mock;
