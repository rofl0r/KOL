program kolmiditest;
//  The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at http://www.mozilla.org/MPL/
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied.
//  See the License for the specific language governing rights and limitations under the License.

//********************************************************************
//  Created by KOL project Expert Version 2.00 on:29-1-2003 11:57:25
//********************************************************************

uses
  Kol,
  midi1 in 'midi1.pas',
  TdkKOLMIDI in 'TdkKOLMIDI.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
  
end.