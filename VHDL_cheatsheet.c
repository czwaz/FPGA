{Design Units:
	ENTITY
		// define external view of a model (symbol)
	ARCHITECTURE
		// define function of the model (schematic)
	CONFIGURATION
		// associate an architecture with an entity
	PACKAGE
		// reusable code (library, toolbox)
###################################################################################################
{//ENTITY
ENTITY <entity_name> IS
	//Generic declarations
	GENERIC (
		CONSTANT bar, foo : TIME := 5 ns;	// CONSTANT is assumed and is not required
		bar2, foo2 : TIME := 3 ns;
		default_value : INTEGER := 1;
		cnt_dir : STRING := "up"
		);
	//Port declarations
	PORT (
		SIGNAL clk, clr : IN BIT; //SIGNAL is assumed and is not required
		//mode: in (input)
		//		out (output)
		//		inout (bidirectional)
		//		buffer (output w/ internal feedback) (tricky to use!!!)
		q : OUT BIT	// no ';' after last signal!
		);
END ENTITY <entity_name>; // or 'END ENTITY;' or 'END;'
}
###################################################################################################
{//ARCHITECTURE
/*ARCHITECTURE must be associated with an ENTITY, statements execute concurrently (processes)
ARCHITECTURE styles
	Behavioral: how designs operate: RTL, Functional
	Structural: netlist: Gate/component level
	Hybrid: mixture of Behavioral and Structural
	*/
ARCHITECTURE <arch_name> OF <entity_name> IS
	//declaration section (local identifiers, which are not ports or generics, must be declared)
	SIGNAL temp : INTEGER := 1;	// (:= 1) default value optional
	CONSTANT load : BOOLEAN := true; // constant declaration
	TYPE states IS ( S1, S2, S3, S4 ); // type declaration (enumerations)
BEGIN
	Process statements
	Concurrent procedural calls
	Concurrent signal assignment
	Component instantiation statements
	Generate statements
END ARCHITECTURE <arch_name>; // or 'END ARCHITECTURE;' or 'END;'
}
###################################################################################################
{//CONFIGURATION
//CONFIGURATION not required as most tools have ability to do bindings automatically
CONFIGURATION <configuration_name> OF <entity_name> IS
	FOR <arch_name>
		FOR.....
		END FOR;
	END FOR;
END CONFIGURATION <configuration_name>;
}
###################################################################################################
{//PACKAGE
/*PACKAGE consist of:
	Package Declaration (required)
		Type declarations
		Subprograms declarations
	Package Body (optional)
		Subprogram definitions

VHDL has two built-in Packages
	Standard - defines build in VHDL data types
	TEXTIO - file operations
	*/
PACKAGE <pack_name> IS
	TYPE state_type IS (idle, tap1, tap2, tap3, tap4);
	FUNCTION compare (variable a, b : INTEGER) RETURN BOOLEAN; // functions are defined in BODY
END PACKAGE <pack_name>;

PACKAGE BODY <pack_name> IS
	FUNCTION compare (variable a, b : INTEGER) is
		VARIABLE temp : BOOLEAN;
	BEGIN
		IF a < b THEN
			temp := true;
		ELSE
			temp := false;
		END IF;
		RETURN temp;
	END FUNCTION compare;
END PACKAGE BODY <pack_name>;
}
}
###################################################################################################
{TYPES defined in standard package (STD)
BIT
	// '0' or '1'
	SIGNAL a_temp : BIT;
	SIGNAL temp : BIT_VECTOR (3 DOWNTO 0);
	SIGNAL temp : BIT_VECTOR (0 TO 3);
BOOLEAN
	// true, false
INTEGER
	// Positive and negative values in decimal
	SIGNAL int_temp : INTEGER; // 32-bit number
	SIGNAL int_temp1 : INTEGER RANGE 0 TO 255; // 8-bit number
NATURAL
	// Integer with range 0 to 2^32
POSITIVE
	// Integer with range 1 to 2^32
CHARACTER
	// ASCII character
STRING
	// Array of characters
TIME
	// Value includes units of time (ps, ns, us, ms, sec, min, hr)
REAL
	// Double-precision floating point numbers
}
###################################################################################################
{Constants
	// Can be declared in ENTITY, ARCHITECTURE or PACKAGE
	// Cannot be changed by executing code
	CONSTANT <name> : <DATA_TYPE> := <value>;
	CONSTANT bus_width : INTEGER := 8;
Signal
	// Can be declared in ENTITY, ARCHITECTURE and PACKAGE
	// represents a physical interconnect (wire) that communicate between processes (functions)
	SIGNAL temp : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
	//Assignments:
		temp <= "00101001";
		temp <= x"aa"; // also supports 'o' for octal and 'b' for binary
		temp ( 7 DOWNTO 4 ) <= "0010";
		temp (7) <= '1';
}
###################################################################################################
{Assignments
//Simple Signal Assignments
	q <= r OR t;
	b <= (q AND NOT ( g XOR h ));
	c <= (OTHERS => '0'); // set all bits of c to '0'
//Conditional Signal Assignments
	<signal_name> <= <signal/value> WHEN <condition_1> ELSE
					 <signal/value> WHEN <condition_2> ELSE
						 ...
					 <signal/value>;
//Selected Signal Assignments
	WITH <expression> SELECT
		<signal_name> <= <signal/value> WHEN <condition_1>,
						 <signal/value> WHEN <condition_2>,
						 ...
						 <signal/value> WHEN OTHERS;

	//(Example mux: input(a,b,sel);output(x,y,z) 
		// simple signal assignment
		x <= (a AND NOT sel) OR (b AND sel);
		// conditional signal assignment
		y <= a WHEN sel='0' ELSE b;
		// selected signal assignment
		WITH sel SELECT
			z <= a WHEN '0',
				 b WHEN '1',
				 '0' WHEN OTHERS;
// Delay:
//Inertial delay (default):
	// A pulse that is short in duration of the propagation delay will not be transmitted
	a <= b AFTER 10 ns;
//Transport delay:
	// Any pulse is transmitted no matter how short
	a <= TRANSPORT b AFTER 10 ns;
}
###################################################################################################
{Operators
Logical:	NOT AND OR NAND NOR XOR XNOR
Relational:	=  /=  <  <=  >  >=
Shifting:	SLL SRL SLA SRA ROL ROR
Arithmetic:	+  -  *  /  MOD  REM  & (Concatenation)
Miscellaneous:	** (exp)  ABS (Absolute value)
}
###################################################################################################
{Process
label: PROCESS (sencitivity_list) // sensitivity list optional (needed for simulation!) PROCESS (all)
	Constant declarations
	Type declarations
	Variable declarations
BEGIN
	Sequential statement # 1;
	...
	Sequential statement # n;
END PROCESS;

{// Sequential Statements: Must be used inside explicit processes
IF-THEN
	IF <condition1> THEN
		{sequence of statement(s)}
	ELSIF <conditions2> THEN
		{sequence of statement(s)}
		...
	ELSE
		{sequence of statement(s)}
	END IF;
	
CASE
	CASE {expression} IS
		WHEN <condition1> =>
			{sequence of statements}
		WHEN <condition2> =>
			{sequence of statements}
		...
		WHEN OTHERS =>
			{sequence of statements}
	END CASE;

Sequential Loops
// LOOP Statement: Loops infinitely unless EXIT statement exists
	[loop_label] LOOP
		--sequential statement
		NEXT loop_label WHEN ...;
		EXIT loop_label WHEN ...;
	END LOOP
// WHILE Loop: conditional test to end loop
	WHILE <condition> LOOP
		--sequential statements
	END LOOP;
// For Loop: Iteration Loop
	FOR <identifier> IN <range> LOOP
		--sequential statements
	END LOOP;
// All loops support NEXT and EXIT

WAIT
// pauses execution of process until WAIT statement is satisfied
	WAIT ON <signal> // pauses until signal event occurs
	WAIT UNTIL <boolean_expression> // pauses until boolean expression is true
	WAIT FOR <time_expression> // pauses until time specified by expression has elapsed
	Combined WAIT
		WAIT UNTIL (a = '1') FOR 5 us; // wait until a = '1' or 5 us have elapsed
}
{Variables
// Variables are declared inside a process ( := )
	VARIABLE <name> : <DATA_TYPE> := <value>;
	VARIABLE temp : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
// Variable assignments are updated immediately
}
{Synchronous Design
IF rising_edge(clk) THEN...  (only '0' --> '1' transition; not 'X','Z',... --> '1')
clk'event and clk = '1'		 ('X','Z',... --> '1' transitions! don't use!)

/*Rule for synchronous logic:
	only clk and all asynchronous signals in sensitivity list
	asynchronous signals checked outside of rising_edge(clk) case
*/
}}
}
###################################################################################################
{Array
// creates multi-dimensional data type for storing values
// must create constant, signal or variable of that type
// Used to create memories and store simulation vectors
	TYPE <array_type_name> is ARRAY (<integer_range>) OF
		<data_type>;

	ARCHITECTURE logic OF my_memory IS
		// Creates new array data type named mem with 64 address locations each 8 bits wide
		TYPE mem IS ARRAY ( 0 to 63 ) OF STD_LOGIC_VECTOR ( 7 downto 0 );
		// Creates 2 - 64x8-bit array to use in design
		SIGNAL mem_64x8_a, mem_64x8_b : mem;
	BEGIN
		...
		mem_64x8_a(12) <= x"AF";
		mem_64x8_b(50) <= "10010010";
		...
	END ARCHITECTURE logic;
}
###################################################################################################
{Enumerated Data Type
// allows to create data type name and values
// must create constant, signal or variable if that type to use
// Used for: making code more readable, Finite state machines
	TYPE <your_data_type> IS
		(data type items or values separated by commas);
	
	TYPE enum IS (idle, fill, heat_w, wash, drain);
	SIGNAL dshwshr_st : enum;
		...
	drain_led <= '1' WHEN dshwsher_st = drain ELSE '0';
}
###################################################################################################
{Components
// VHDL hierarchical design requires Component Declarations and Component Instantiations
// Component declaration - declare Port types and Data types of ports for lower-level design
	COMPONENT <lower-level_design_name>
		PORT (
			<port_name> : <port_type> <data_type>;
			...
			<port_name> : <port_type> <data_type>
			);
	END COMPONENT;
// Component Instantiations - map ports of lower-level design to current-level design
	<instance_name> : <lower-level_design_name>
		PORT MAP (<lower-level_design_name> => <current_level_port_name>,
					...,
				  <lower-level_design_name> => <current_level_port_name>
				  );

// Example:
	LIBRARY IEEE;
	USE IEEE.std_logic_1164.ALL;
	ENTITY tolleab IS
		PORT (
			tclk, tcross, tnickel, tdime, tquarter : IN std_logic;
			tgreen, tred : OUT std_logic
			);
	END ENTITY tolleab;
	ARCHITECTURE tolleab_arch OF talleab IS
		
		COMPONENT tollv
			PORT (
				clk, cross, nickel, dime, quarter : IN std_logic;
				green, red : OUT std_logic
				);
		END COMPONENT;
	
	BEGIN
	
	U1 : tollv PORT MAP (clk => tclk, cross => tcross,
						...
						red => ted);
	END ARCHITECTURE tolleab_arch;

	
}
###################################################################################################



















