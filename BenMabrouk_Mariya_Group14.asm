; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    count db 0
    count2 dw 0
    count3 dw 0
    count4 dw 0
    count5 db 0
    count6 dw 0
    count7 dw 0 
    counter dw -1
    counter2 dw -1
    contacts db 400 dup(0)  ; Array for storing contacts
    ordredContacts db 400 dup(0)  ;array for ordered contacts
    nameChoisi db 20 dup(0)
    namePrefix db 20 dup(0)
    displayName db 30 dup(20)
    numberPrefix db 20 dup(0)
    counter3 dw 0
    length dw 1
    lengthOrdredContacts dw 0
    lengthname dw 0 
    endname db 0
    endname2 dw 0
    namemod db 20 dup(0)
    namedel db 20 dup(0)
    countname db 0 
    lengthNum dw 0 
    displayNumber db 20 dup(0)
    newline db 13,10,'$'
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    include emu8086.inc    ;include emu8086.enc library to use the function printn
  ;-----------------------------------------------------
  ;              menu
  ;-----------------------------------------------------
 ;  printn '********************************'
 ;  printn '*°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*'  
 ;  printn '*°°°°°     °°     °° S°°°°°°°°°*'    
 ;  printn '*°°°°° °°°°°° °°°°°° Y°°°°°°°°°*'    
  ; printn '*°°°°° °°°°°° °°°°°° S°°°°°°°°°*'    
 ;  printn '*°°°°°     °°     °° T°°°°°°°°°*'    
  ; printn '*°°°°° °°°°°°°°°° °° E°°°°°°°°°*'    
   ;printn '*°°°°° °°°°°°°°°° °° M°°°°°°°°°*'    
  ; printn '*°°°°°     °°     °° 2°°°°°°°°°*'
 ;  printn '*°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*'
  ; printn '*°°Benmabrouk°Mariya°Group°14°°*'
   ;printn '*°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*'
 ;  printn '********************************' 
   menu:                            
  ; printn ' '    ; Print an empty line for spacing
  ; printn ' ------------------------------ '
   printn '| Choose an operation :                      |'
;   printn '|  1->   add a contact                       |'
 ;  printn '|  2->   view all contacts         |'
  ; printn '|  3->   search a contact      |'
   ;printn '|  4->   modify a contact      |'
  ; printn '|  5->   delete a contact      |'
  ; printn '|  6->   display all contacts whose name starts with the given prefix'
  ; printn '|  7->   display all contacts whose phone numper starts with the given prefix'
   ;printn '|  8->   exit                  |'
  ; printn ' ------------------------------ ' 
   mov ax,0
   mov [endname],0
   mov [endname2],0
   ; Wait for user input
   mov ah,01
   int 21h
 ;----------------------------------------------
 ;                 add content                 
 ;----------------------------------------------
   addContant:
   cmp al,'1'    ; Check if the user pressed '1' (Add Contact)
   jne ViewAllContact    ; If not jump to ViewAllContact
   mov bl,[count]
   cmp bl,16
   je AddressBookFull
   inc [count]     ; Increment contact count
   inc [count2]
   printn 'enter the information of the contact' 
   printn '    enter the name'
      mov [contacts],' '  ; Initialize by inserting a space at the beginning 
      
      LoopName:
      mov ah,1
      int 21h
      cmp al,13  ; Initialize by inserting a space at the beginning 
      je enternumber 
      mov si,[length]
      mov di,[lengthOrdredContacts]
      inc [length]                                                                     
      inc [endname]
      inc [endname2]
      mov [contacts+si],al 
      cmp [endname],10
      je enternumber
      jmp LoopName
   enternumber:
   mov dx,10
   sub dx,[endname2]
   mov [contacts+si+1],' '
   printn '    enter the number (contain 10 digits)'
   mov cx,10
       LoopNumber:
       mov ah,1
       int 21h
       inc [length]
       mov si,[length]
       mov [contacts+si],al
       loop LoopNumber
       mov [contacts+si+1],' '    ; Initialize by inserting a space at the beginning 
       mov [contacts+si+2],'$'    ; Add end marker ('$') to indicate end of contact
       add [length],2
   jmp menu
   AddressBookFull:
   printn 'the address book is full, you can not add a contact '
   jmp menu
   ;--------------------------------------------
   ;                   view all contents
   ;--------------------------------------------
   ViewAllContact:
   cmp al,'2'    ; Check if the user pressed '2' (view all Contact)
   jne SearchContact  ; If not jump to Search for a Contact
   ; Check if the address book is empty
   mov bl,[count]
   cmp bl,0
   jne notEmpty   ; If not empty, continue
   printn 'the address book is empty'
   jmp menu
   notEmpty:
   printn '   '  ; Print an empty line for spacing
   mov bl,[count]
   cmp bl,1
   je exist1
   mov si,1    ; Start from position 
   mov di,0
   mov dx,0
    etMov1:
      mov al,[contacts+si]
      cmp al,'$'     ; Check if end of contacts
      je etMov2      ; If '$' found, move to next step
      etMov3:
       mov al,[contacts+si]
       cmp al,' ' 
       je etMov4
       mov [ordredContacts+di],al
       inc dx
       inc si
       inc di
       jmp etMov3
       etMov4:
         mov [count7],10
         sub [count7],dx   ; Calculate how many spaces are needed
         mov dx,0
         add di,[count7]
         inc si
         ; Calculate how many spaces are needed
         mov cx,10
         etMov5:
          mov al,[contacts+si]
          mov [ordredContacts+di],al
          inc si
          inc di 
         loop etMov5
         inc si
    jmp etMov1
    etMov2:
      mov [ordredContacts+di],'$' 
   mov ax,[count2]
     cmp ax,1
     je et5
   mov cx,[count2]
   et1:
     mov ax,0
     mov [count6],1
     et2:
       mov bx,[count6]
       cmp bx,[count2]
       je  et5
       mov bl,20
       mul bl
       mov si,ax
       div bl
       add ax,1
       mul bl
       mov di,ax
       div bl
       mov [count3],si
       mov [count4],di
       mov [count5],0
       inc [count6]
       et3:
         mov dl,0
         inc [count5]
         mov bl,[ordredContacts+si]
         cmp bl,[ordredContacts+di]
         jl et2
         jg et4
         inc si
         inc di
         mov bh,[count5]
         cmp bh,20
         je et2
         jmp et3
         et4:
           mov si,[count3]
           mov di,[count4]
           et6:
             mov bl,[ordredContacts+si]
             mov bh,[ordredContacts+di]
             mov [ordredContacts+si],bh
             mov [ordredContacts+di],bl
             inc si
             inc di
             inc dl
             cmp dl,20
             je et2
             jmp et6
      et5:       
   loop et1 
   lea dx,ordredContacts
   mov ah,9
   int 21h
   jmp menu
   exist1:
    ; If only one contact, directly print contacts
   lea dx,contacts
   mov ah,9
   int 21h
   jmp menu 
   ;---------------------------------------------------------
   ;                   search a content
   ;---------------------------------------------------------
   SearchContact:
   cmp al,'3'       ; Check if the user pressed '3' (Search a contact)
   jne ModifyContact  ; If not jump to ModifyContact
    ; Check if the address book has any contacts
   cmp [length],1
    je isempty  ; If no contacts, display message
   printn 'enter the name of the contact that you need to find it'
   mov si,1
   mov [nameChoisi],' '
   ; Read user input for the name
       choicename:
        mov ah,1
        int 21h
        cmp al,13
        je compare
        mov [nameChoisi+si],al
        cmp si,10
        je compare
        inc si
        loop choicename 
        compare:
        mov [nameChoisi+si],' '
        inc si
        mov [nameChoisi+si],'.'
        mov [lengthname],si       
    mov si,0
    mov di,0
    co: 
        cmp [contacts+si],'$'
        je notexist
        inc [counter]
        first:
           mov bl,[nameChoisi+di]
           mov al,[contacts+si]
           cmp al,bl
           jne ne
           eq:
             inc di
             inc si
             mov dl,[nameChoisi+di]
             cmp dl,'.'
             jne first
             je exist
           ne: 
           inc si
           sub si,di
           mov di,0 
     jmp co
     exist:
       printn 'is exist'
       printn 'the number of this name is :'
       mov cx,10
       mov si,0
       add si,[counter]
       add si,[lengthname]
       readNumber:
       mov dl,[contacts+si]
       inc si
       mov ah,2
       int 21h
       loop readNumber 
       jmp menu
    notexist:
       printn 'this name does not exist in the address book'
       jmp menu
    isempty:
       printn 'the address book is empty'
       jmp menu
   ;---------------------------------------------
   ;              modify contact
   ;---------------------------------------------
   ModifyContact:
   cmp al,'4'
   jne DeleteContact
   mf:
   printn '--------------------------'
   printn '     1-chooce a name'          
   printn '     2-exit'
   printn '--------------------------'
   mov ah,1
   int 21h
   byname: 
   cmp al,'1'
   jne ex
   
      printn 'enter the name of the contact that you need to modify its number'
      mov [counter2],-1
      mov [counter3],0
      mov si,1
      mov [namemod],' '
      namemodify:
        mov ah,1
        int 21h
        cmp al,13
        je fnm
        mov [namemod+si],al
        cmp si,10
        je fnm
        inc si
      jmp namemodify
      fnm:
      mov [namemod+si],' '
      inc si
      mov [namemod+si],'.'
      mov [counter3],si 
      
      mov si,0
      mov di,0
      repeat:
       mov al,[contacts+si]
       cmp al,'$' 
       je NameNotExist
       inc [counter2]
       booclecmp:
          mov al,[contacts+si]
          cmp al,[namemod+di]
          jne notEqCmp
            inc si
            inc di
            mov al,[namemod+di]
            cmp al,'.'
            jne booclecmp
            je NameExist
          notEqCmp:
            sub si,di
            xor di,di
            inc si
       jmp repeat
       
       NameNotExist:
       printn 'this name does not exist in the address book'
       jmp mf
       NameExist:
       printn 'this name is exist in the address book'
       printn 'enter the new number'
       mov si,[counter2]
       add si,[counter3]
       mov cx,10
       newNumber:
         mov ah,1
         int 21h
         mov dl,al
         mov [contacts+si],al
         inc si
       loop newNumber
       
       jmp mf    
   ex:
   cmp al,'2'
   jne notex
   printn 'exit'
   jmp  menu
   notex:
   printn 'this option does not exist'
   jmp mf 
   ;--------------------------------------------- 
   ;              delete a contact
   ;---------------------------------------------
   DeleteContact:
   cmp al,'5'
   jne nameStart
   printn 'enter the name of the contact that you need to delete it'
   mov [counter3],0
   mov [counter2],-1
    mov si,1
      mov [namedel],' '
      namedelete:
        mov ah,1
        int 21h
        cmp al,13
        je fnmdel
        mov [namedel+si],al
        cmp si,10
        je fnmdel
        inc si
      jmp namedelete
      fnmdel:
      mov [namedel+si],' '
      inc si
      mov [namedel+si],'.'
      mov [counter3],si
       
      mov si,0
      mov di,0 
      CmpNameDel:
         cmp [contacts+si],'$'
         je NameDelNotExist
         inc [counter2]
         repeatCmp:
           mov al,[contacts+si]
           cmp al,[namedel+di]
           jne ndel
           inc si 
           inc di
           mov al,[namedel+di]
           cmp al,'.'
           je NameDelExist
         jmp repeatCmp
           ndel:
             sub si,di
             xor di,di
             inc si
       jmp CmpNameDel
       NameDelNotExist:
           printn 'this name does not exist in the address book'
           jmp menu
       NameDelExist:
           printn 'this name is exist in the address book'
           dec [count]
           mov si,[counter2]
           mov di,[counter2]
           add di,[counter3]
           add di,10
           mov cx,[length]
           add cx,24
           boocleDelete:
           mov al,[contacts+di]
           mov [contacts+si],al
           inc si
           inc di
           loop boocleDelete
           printn 'the contacts after deletion (not ordred)'
           lea dx,contacts
           mov ah,9
           int 21h
           jmp menu
   ;---------------------------------------------
   ;   display all contacts whose name starts with the given prefix
   ;---------------------------------------------
   nameStart:
   cmp al,'6'
   jne phoneNumperStart
   printn 'enter the prefix name of the contacts that you need to desplay it'
      mov [countname],0
      mov si,1
      mov [namePrefix],' '
      namestartPrefix:
        mov ah,1
        int 21h
        cmp al,13
        je fnamePre
        mov [namePrefix+si],al
        inc si
        cmp si,11
        je fnamePre
       jmp namestartPrefix
      fnamePre:
      mov [namePrefix+si],'.'
      ;_____________________________________________ 
      mov si,0
      mov di,0
      mov [counter2],0
       repeatcmpPrefixName:
       mov al,[contacts+si]
       cmp al,'$' 
       je prefixNameNotExist
       inc [counter2]
       booclecmpPrefix:
          mov al,[contacts+si]
          cmp al,[namePrefix+di]
          jne notEqCmpPrnumper
            inc si
            inc di
            mov al,[namePrefix+di]
            cmp al,'.'
            jne booclecmpPrefix
            je prefixNameExist
          notEqCmpPrnumper:
            sub si,di
            xor di,di
            inc si
       jmp repeatcmpPrefixName
      prefixNameExist:
       mov si,[counter2]
       mov di,0 
       textdisplayName:
       mov al,[contacts+si]
       mov [displayName+di],al
       inc si
       inc di
       cmp al,' '
       jne textdisplayName
       mov cx,10
       textdisplayNameLoop:
       mov al,[contacts+si]
       mov [displayName+di],al
       inc si
       inc di
       loop textdisplayNameLoop
       mov [displayName+di],'$'
       lea dx,displayName
       mov ah,9
       int 21h
       dec di
       add [counter2],di
       mov dl,[contacts+si+1]
       inc [countname]
       mov di,0 
       cmp dl,'$'
       jne repeatcmpPrefixName
      jmp menu
      
      
      prefixNameNotExist:
      mov bl,[countname]  
      cmp bl,0
      je menu
      printn 'this prefix does not exist'
      jmp menu
      
      
        
   ;---------------------------------------------
   ;   display all contacts whose phone number contains the given prefix
   ;---------------------------------------------
   phoneNumperStart:
   cmp al,'7'
   jne Exit
   printn 'enter the prefix number of the contacts that you need to desplay it'
   mov si,0
   numberPrefixInclude:
      mov ah,1
      int 21h
      cmp al,13
      je fnumberpre
      mov [numberPrefix+si],al
      inc si
      cmp si,11
      je  fnumberpre
    jmp numberPrefixInclude
     fnumberpre:
     mov [namePrefix+si],'.'
   ;______________________________
   mov [counter2],0
      mov si,0
      mov di,0
      repeatCmpPrefixNumber:
       mov al,[contacts+si]
       cmp al,'$' 
       je prefixNumperNotExist
       inc [counter2]
       booclecmppreNumber:
          mov al,[contacts+si]
          cmp al,[namePrefix+di]
          jne notEqCmpPrefNum
            inc si
            inc di
            mov al,[namePrefix+di]
            cmp al,'.'
            jne booclecmppreNumber
            je prifixNumberExist
          notEqCmpPrefNum:
            sub si,di
            xor di,di
            inc si
       jmp repeatCmpPrefixNumber
    
     prefixNumperNotExist:
      printn 'this prefix does not exist'
      jmp menu
     prifixNumberExist:
     mov si,[counter2]
     mov [lengthNum],0
     LengthNumber:
       mov al,[contacts+si]
       cmp al,' '
       je finLengthNumber
       inc si
       inc [lengthNum]
     jmp LengthNumber
     finLengthNumber:
     mov dx,10
     sub dx,[lengthNum]
     sub si,dx
     sub si,2
     looptext:
      mov al,[contacts+si]
      cmp al,' '
      inc si
      je  finlooptext 
     jmp looptext
     finlooptext:
     textdisplayNumber:
       mov al,[contacts+si]
       mov [displayNumber+di],al
       inc si
       inc di
       cmp al,' '
       jne textdisplayNumber
       mov cx,10
       textdisplayNumberLoop:
       mov al,[contacts+si]
       mov [displayNumber+di],al
       inc si
       inc di
       loop textdisplayNumberLoop
       mov [displayNumber+di],'$'
       lea dx,displayNumber
       mov ah,9
       int 21h
       mov di,0
       mov [counter2],si 
       mov dl,[contacts+si+1]
       cmp dl,'$'
       jne repeatCmpPrefixNumber
   jmp menu 
   ;---------------------------------------------
   ;                exit
   ;---------------------------------------------
   Exit:
   cmp al,'8'
   jne OptionDoesNotExist
   printn 'Exit'
   jmp finally
   ;---------------------------------------------
   ;option does not exis
   ;---------------------------------------------
   OptionDoesNotExist:
   printn 'This option does not exist'
   jmp menu
   ;_____________________________________________
    
    finally:  
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.