--with driver_pcm3712_ao_ehu; use driver_pcm3712_ao_ehu;
--with driver_pcm3718_ai; use driver_pcm3718_ai;
with geme_mock; use geme_mock;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body mockup_control is

    procedure heat(power: Float) is
      volts: Float;
      power_aux: Float;
      begin
      	--Put("Power Signal: ");
      	--Put(power);
         power_aux := power;
      if power > 350.0 then
         power_aux := 350.0;
         Put_Line("Potencia Limitada a 350 W");
 	end if;
      if power < 50.0 then
          power_aux := 50.0;
          Put_Line("Potencia Minima 50 W");
      end if;
        volts := power_aux / gain_wats_volt;
        Write_ao_PCM3712(volts);
    end heat;

    function read_temp return Float is
    temp: Float;
    begin
        temp := Adquirir * gain_volt_temp;
    return temp;
    end read_temp;

    procedure close is
    begin
        Fin_Adquisicion;
    end close;

begin
    Initialize_PCM3712;
    --Configuracion_Inicial(Conexion => Differential_Ended, Canal_Primero => 0, Canal_Ultimo=>0, Disparo => Software, Numero_muestras => 1, Rango => Unipolar_5);
    heat(50.0);
end mockup_control;
