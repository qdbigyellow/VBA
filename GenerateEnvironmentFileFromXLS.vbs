Sub Button3_Click()
    Dim i As Integer
    Dim reqSheet As Worksheet
    
    Set reqSheet = ThisWorkbook.Worksheets("Config")
    i = 2
    Do While reqSheet.Cells(i, 1).Value <> ""
        Call CreateAfile(i)
        i = i + 1
    Loop
    
End Sub

Sub CreateAfile(i As Integer)
      Dim port1 As String, port2 As String, segment As String, postfix As String, prefix As String, prefix2 As String, postfix2 As String, versionnr As String, installation As String
      port1 = Cells(i, 2).Value
      port2 = Cells(i, 3).Value
      segment = Cells(i, 4).Value
      prefix = Cells(i, 5).Value
      postfix = Cells(i, 6).Value
      prefix2 = Cells(i, 7).Value
      postfix2 = Cells(i, 8).Value
      versionnr = Cells(i, 9).Value
      installation = Cells(i, 1).Value
                  
      If prefix <> "" And prefix2 <> "" Then
          prefix2 = "_" + prefix2
      End If
                  
      If postfix <> "" And postfix2 <> "" Then
          postfix2 = "_" + postfix2
      End If
      
      If InStr(UCase(installation), "DEV") = 0 Then
          prefix2 = prefix2 + "_" + Replace(versionnr, ".", "")  'The version number always after 2nd prefix
      End If
          
      Dim filename As String, filepath As String, fullpath As String
      filepath = "F:\JIH\ServiceFramework\Environment\"
      If prefix <> "" Then
          If postfix <> "" Then
              filename = prefix + prefix2 + "_Environment_" + postfix + ".cmd"
          Else
              filename = prefix + prefix2 + "_Environment.cmd"
          End If
      Else
          If postfix <> "" Then
              filename = "Environment_" + postfix + postfix2 + ".cmd"
          Else
              filename = "Environment.cmd"
          End If
      End If
      fullpath = filepath + filename
      
      Dim dt As String, un As String
      
      
      Set fs = CreateObject("Scripting.FileSystemObject")
      Set a = fs.CreateTextFile(fullpath, True)
      
      dt = Format(Now(), "yyyy-MM-dd hh:mm:ss")
      un = Environ$("UserName")
      
      a.WriteLine ("rem " + Chr(34) + "This script is generated by F:\MyFolder\ServiceFramework\PortDistribution.xlsm @" + dt + " by " + un + Chr(34))
      a.WriteLine ("rem " + Chr(34) + "Copyright@Bigyellow" + Chr(34))
      a.WriteLine ("echo " + Chr(34) + "Directory service is provided by current machine" + Chr(34))
      a.WriteLine ("@echo off")
      If Cells(i, 3).Value <> "" Then
          If Cells(i, 2).Value <> "" Then
              If LCase(Cells(i, 5).Value) <> "citrix" Then
                    a.WriteLine ("set DIRSVC=mycomputername.mydomain.com," + port1 + ";mycomputername.mydomain.com," + port2) 'Hardcode the local machine name
              Else
                    a.WriteLine ("set DIRSVC=%computername%.scdom.net," + port1 + ";%computername%.scdom.net," + port2)
              End If
          Else
              If LCase(Cells(i, 5).Value) <> "citrix" Then
                    a.WriteLine ("set DIRSVC=mycomputername.mydomain.com," + port2)
              Else
                    a.WriteLine ("set DIRSVC=%computername%.scdom.net," + port2)
              End If
            
          End If
      Else
          a.WriteLine ("set DIRSVC=%computername%.scdom.net," + port1)
      End If
      a.WriteLine ("set SEGMENT=" + segment)
      a.WriteLine ("echo " + Chr(34) + "Following environment is taken into use" + Chr(34))
      a.WriteLine ("set DIRSVC")
      a.WriteLine ("set SEGMENT")
      a.WriteLine ("set CNFPARAMS= -!svcdirectoryservice=%DIRSVC% -!svcservicesegment=%SEGMENT%")
      a.Close

End Sub
