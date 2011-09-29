-------------------------------------------------------------------------------
--                                                                           --
--                          Mandelbrot Set Generator                         --
--                                                                           --
--                             Mandelbrot_Set.adb                            --
--                                                                           --
--                                   BODY                                    --
--                                                                           --
--                   Copyright (C) 1996 Ulrik Hørlyk Hjort                   --
--                                                                           --
--  Mandelbrot Set Generator is free software;  you can  redistribute it     --
--  and/or modify it under terms of the  GNU General Public License          --
--  as published  by the Free Software  Foundation;  either version 2,       --
--  or (at your option) any later version.                                   --
--  Mandelbrot Set Generator is distributed in the hope that it will be      --
--  useful, but WITHOUT ANY WARRANTY;  without even the  implied warranty    --
--  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  --
--  See the GNU General Public License for  more details.                    --
--  You should have  received  a copy of the GNU General                     --
--  Public License  distributed with Yolk.  If not, write  to  the  Free     --
--  Software Foundation,  51  Franklin  Street,  Fifth  Floor, Boston,       --
--  MA 02110 - 1301, USA.                                                    --
--                                                                           --
-------------------------------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Interfaces; use Interfaces;

package body Mandelbrot_Set is

   C_Real_Min : Float := 0.0;
   C_Img_Min  : Float := 0.0;
   C_Real_Max : Float := 0.0;
   C_Img_Max  : Float := 0.0;

   Iterations : Positive := 1;

   UseColorMap : Boolean     := False;
   ShiftFactor : Positive    := 1;
   ColorMask   : Unsigned_32 := 16#000000#;
   ColorDetail : Positive    := 1;


   ----------------------------------------------------------
   -- Read the data set from the file Filename containing the
   --
   ----------------------------------------------------------
   Procedure Read_Data(Filename : String) is

      Data_File      : FILE_TYPE;
      Mask           : Integer;
      Color_Map_Flag : Integer := 0;

   begin
      Open(Data_File, In_File, Filename);

      while not End_Of_File(Data_File) loop
         if End_Of_Line(Data_File) then
            Skip_Line(Data_File);
         else
            Get(Data_File, C_Real_Min);
            Get(Data_File, C_Img_Min);
            Get(Data_File, C_Real_Max);
            Get(Data_File, C_Img_Max);
            Get(Data_File, Iterations);
            Get(Data_File, ShiftFactor);
            Get(Data_File, ColorDetail);
            Get(Data_File, Mask);
            ColorMask := Unsigned_32(Mask);
            Get(Data_File, Color_Map_Flag);

            if Color_Map_Flag = 1 then
               UseColorMap := True;
            else
               UseColorMap := False;
            end if;

         end if;
      end loop;
      Close(Data_File);
   exception
      -- Constraint_Error aaised if empty lines in
      -- the data file. We ignore this.
      when Constraint_Error =>
      Close(Data_File);
   end Read_Data;




   procedure Generate(Filename : String; Image_Width : Positive; Image_Height : Positive) is
     Out_Filename : constant String := Filename & ".tga";
     Tga_Buffer   : Tga_24bit_RGB_Buffer_T(1..Image_height, 1..Image_Width);

     C_Real_Step   :  Float     := 0.0;
     C_Img_Step    : Float      := 0.0;

     C_Real,C_Img  : Float      := 0.0;

     Z_Real,
     Z_Img,
     Z_Real_Tmp,
     Z_Img_Tmp    : Float       := 0.0;

     Print_Color  : Boolean     := False;
     Color        : Unsigned_24 := 0;
     ByteColor    : Unsigned_8  :=0;

   begin
     Read_Data(Filename & ".dat");

     C_Real_Step := (C_Real_Max-C_Real_Min)/Float(Image_Width);
     C_Img_Step := (C_Img_Max-C_Img_Min)/Float(Image_Height);


     C_Real := C_Real_Min;
     C_Img := C_Img_Min;

     for Height in 1 .. Image_Height loop
        for Width in 1 .. Image_Width loop

            Print_Color := False;
            Z_Real      := 0.0;
            Z_Img       := 0.0;

            Inner_Loop:
            for Iteration in 1 .. Iterations loop
               Z_Real_Tmp := (Z_Real ** 2) - (Z_Img ** 2) + C_Real;
               Z_Img_Tmp  :=  (2.0 * Z_Real * Z_Img) + C_Img;
               Z_Real     := Z_Real_Tmp;
               Z_Img      := Z_Img_Tmp;

               if ((Z_Real ** 2) - (Z_Img ** 2) > 4.0) then
                  Print_Color := True;

                  if UseColorMap then
                     ByteColor := Unsigned_8(Iterations/256) * Unsigned_8(Iteration mod 256);
                     Color := ColorMap(Positive((Iteration mod 255)+1));
                  else
                     Color := Unsigned_24((Shift_Left(Unsigned_32(Iteration *ColorDetail),shiftFactor) mod (2 ** 24-1)) or ColorMask);
                  end if;

               end if;
             exit Inner_Loop When Print_Color;
            end loop Inner_Loop;

            if Print_Color then
              Insert_Point(Tga_Buffer,Height,Width,Color);
            else
              Insert_Point(Tga_Buffer,Height,Width,16#000000#);
            end if;
            C_Real := C_Real + C_Real_Step;
        end loop;
        C_Img  := C_Img + C_Img_Step;
        C_Real := C_Real_Min;
     end loop;

    Save_Image(Out_Filename,Tga_Buffer,Unsigned_16(Image_Height),Unsigned_16(Image_Width));
   end Generate;

end Mandelbrot_Set;
