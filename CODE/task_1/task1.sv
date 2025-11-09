`include "uvm_macros.svh"
import uvm_pkg::*;
typedef enum {read , write } trans_types;

// Packet class definition
class task1_packet extends uvm_sequence_item;
`uvm_object_utils(task1_packet);
rand logic [0:31] address;
rand logic [0:31] data;
rand trans_types transaction_type; // 0 - read , 1 - write

function new(string name = "task1_packet");
    super.new(name);
endfunction

constraint addr_c { address inside {[0:255]}; }
constraint data_c {data inside {[0:255]}; }

endclass : task1_packet

// Sequence class definition
class task1_sequence extends uvm_sequence #(task1_packet);
    `uvm_object_utils(task1_sequence);

    function new(string name = "task1_sequence");
        super.new(name);
    endfunction


    task body();
        task1_packet pkt,pkt_copy ;
        bit result;

        pkt = task1_packet::type_id::create("pkt");
        void'(pkt.randomize());

        pkt_copy = new pkt ; //shallow copy 
    
        `uvm_info("Original Packet",$sformatf("Original Packet: Address = %0d, Data = %0d, Type = %0d", pkt.address, pkt.data, pkt.transaction_type), UVM_MEDIUM);
        `uvm_info("copied Packet",$sformatf("copied Packet: Address = %0d, Data = %0d, Type = %0d", pkt_copy.address, pkt_copy.data, pkt_copy.transaction_type), UVM_MEDIUM);

        result = pkt.compare(pkt_copy);
        if (result) begin
            `uvm_info("COMPARE",$sformatf("Packets are identical result  = %0d",result), UVM_LOW);
        end else begin
            `uvm_info("compare", "Packets differ", UVM_LOW);
        end

    endtask
endclass 

//simple test class definition
class task1_test extends uvm_test;
    `uvm_component_utils(task1_test)

    function new(string name = "task1_test" , uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        task1_sequence seq;
        phase.raise_objection(this);
            seq = task1_sequence::type_id::create("seq");
            seq.start(null);
        phase.drop_objection(this);
    endtask
endclass 

// Top-level module to run the test
module top;
    import uvm_pkg::*;
    initial begin
        run_test("task1_test");
    end
endmodule