
#----------------------------------------------------------------------

# from https://forth-standard.org/standard/exception
# messages -1 to -255 are defined in standart
# messages above 4095 are system defined

#----------------------------------------------------------------------

msg_1:
	.asciz " ABORT " 
msg_2:
	.asciz " ABORT\" " 
msg_3:
	.asciz " stack overflow " 
msg_4:
	.asciz " stack underflow " 
msg_5:
	.asciz " return stack overflow " 
msg_6:
	.asciz " return stack underflow " 
msg_7:
	.asciz " domsg_loops nested too deeply during execution " 
msg_8:
	.asciz " dictionary overflow " 
msg_9:
	.asciz " invalid memory address " 
msg_10:
	.asciz " division by zero " 
msg_11:
	.asciz " result out of range " 
msg_12:
	.asciz " argument type mismatch " 
msg_13:
	.asciz " undefined word " 
msg_14:
	.asciz " interpreting a compile only word " 
msg_15:
	.asciz " invalid FORGET " 
msg_16:
	.asciz " attempt to use zero length string as a name " 
msg_17:
	.asciz " pictured numeric output string overflow " 
msg_18:
	.asciz " parsed string overflow " 
msg_19:
	.asciz " definition name too long " 
msg_20:
	.asciz " write to a read only location " 
msg_21:
	.asciz " unsupported operation " 
msg_22:
	.asciz " control structure mismatch " 
msg_23:
	.asciz " address alignment exception " 
msg_24:
	.asciz " invalid numeric argument " 
msg_25:
	.asciz " return stack imbalance " 
msg_26:
	.asciz " loop parameters unavailable " 
msg_27:
	.asciz " invalid recursion " 
msg_28:
	.asciz " user interrupt " 
msg_29:
	.asciz " compiler nesting " 
msg_30:
	.asciz " obsolescent feature " 
msg_31:
	.asciz " >BODY used on non CREATEd definition " 
msg_32:
	.asciz " invalid name argument (e.g., TO name) " 
msg_33:
	.asciz " block read exception " 
msg_34:
	.asciz " block write exception " 
msg_35:
	.asciz " invalid block number " 
msg_36:
	.asciz " invalid file position " 
msg_37:
	.asciz " file I/O exception " 
msg_38:
	.asciz " non existent file " 
msg_39:
	.asciz " unexpected end of file " 
msg_40:
	.asciz " invalid BASE for floating point conversion " 
msg_41:
	.asciz " loss of precision " 
msg_42:
	.asciz " floating point divide by zero " 
msg_43:
	.asciz " floating point result out of range " 
msg_44:
	.asciz " floating point stack overflow " 
msg_45:
	.asciz " floating point stack underflow " 
msg_46:
	.asciz " floating point invalid argument " 
msg_47:
	.asciz " compilation word list deleted " 
msg_48:
	.asciz " invalid POSTPONE " 
msg_49:
	.asciz " search order overflow " 
msg_50:
	.asciz " search order underflow " 
msg_51:
	.asciz " compilation word list changed " 
msg_52:
	.asciz " control flow stack overflow " 
msg_53:
	.asciz " exception stack overflow " 
msg_54:
	.asciz " floating point underflow " 
msg_55:
	.asciz " floating point unidentified fault " 
msg_56:
	.asciz " QUIT " 
msg_57:
	.asciz " exception in sending or receiving a character " 
msg_58:
	.asciz " [IF], [ELSE], or [THEN] exception " 
msg_59:
	.asciz " ALLOCATE " 
msg_60:
	.asciz " FREE " 
msg_61:
	.asciz " RESIZE " 
msg_62:
	.asciz " CLOSE FILE " 
msg_63:
	.asciz " CREATE FILE " 
msg_64:
	.asciz " DELETE FILE " 
msg_65:
	.asciz " FILE POSITION " 
msg_66:
	.asciz " FILE SIZE " 
msg_67:
	.asciz " FILE STATUS " 
msg_68:
	.asciz " FLUSH FILE " 
msg_69:
	.asciz " OPEN FILE " 
msg_70:
	.asciz " READ FILE " 
msg_71:
	.asciz " READ LINE " 
msg_72:
	.asciz " RENAME FILE " 
msg_73:
	.asciz " REPOSITION FILE " 
msg_74:
	.asciz " RESIZE FILE " 
msg_75:
	.asciz " WRITE FILE " 
msg_76:
	.asciz " WRITE LINE " 
msg_77:
	.asciz " Malformed xchar " 
msg_78:
	.asciz " SUBSTITUTE " 
msg_79:
	.asciz " REPLACES " 

#----------------------------------------------------------------------

msg_256:
	.asciz " NOT DEFINED " 

#----------------------------------------------------------------------
