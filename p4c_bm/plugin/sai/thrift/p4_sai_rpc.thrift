# P4 SAI thrift definition file

//:: api_prefix = p4_prefix + "_sai"

namespace py p4_sai_rpc
namespace cpp p4_sai_rpc

typedef i32 EntryHandle_t
typedef i32 MemberHandle_t
typedef i32 GroupHandle_t
typedef string MacAddr_t
typedef string IPv6_t

typedef i32 SessionHandle_t
struct DevTarget_t {
  1: required byte dev_id;
  2: required i16 dev_pipe_id;
}


union sai_attribute_value {
    1: bool booldata;
    2: string chardata;
    3: byte u8;
    4: byte s8;
    5: i16 u16;
    6: i16 s16;
    7: i32 u32;
    8: i32 s32;
    9: i64 u64;
    10:i64 s64;
    11:list<byte> mac;
    /*
    11: sai_mac_t mac;
    12: sai_ip4_t ip4;
    13: sai_ip6_t ip6;
    14: sai_ip_address_t ipaddr;
    15: sai_port_list_t portlist;
    16: sai_next_hop_list_t nhlist;
    17: sai_acl_field_data_t aclfield;
    18: sai_acl_action_data_t acldata;
    */
}

struct sai_attribute {
    1: i32 id;
    2: sai_attribute_value value;
}

struct sai_attribute_list {
    1: i32 api_id;  // 1 - 13 (SWITCH-HOST_INTERFACE)
    2: i32 count; // Not needed as list count should get us this
    3: list<sai_attribute> attr_list;
}

//:: from common import *

# Match structs

//:: for table, t_info in table_info.items():
//::   if not t_info["match_fields"]:
//::     continue
//::   #endif
//::   match_params = gen_match_params(t_info["match_fields"], field_info)
struct ${api_prefix}_${table}_match_spec_t {
//::   id = 1
//::   for name, width in match_params:
//::     type_ = get_type(width)
  ${id}: required ${type_} ${name};
//::   id += 1
//::   #endfor
}

//:: #endfor


service ${api_prefix} {
    # Test echo interface
    void echo(1:string s);

    # static functions
//:: name = "init"
    void ${name}();

//:: name = "cleanup"
    void ${name}();

//:: name = "client_init"
    SessionHandle_t ${name}(1:i32 max_txn_size);

//:: name = "client_cleanup"
    i32 ${name}(1:SessionHandle_t sess_hdl);

//:: for table, t_info in table_info.items():
//  ${table} API thrift interfaces
//::   has_match_spec = len(t_info["match_fields"]) > 0
//::   act_prof_name = t_info["action_profile"]
//::   if act_prof_name is None:
//::     if has_match_spec:
    i32 create_${table}(1: ${api_prefix}_${table}_match_spec_t match, 2: sai_attribute_list attr);
    i32 delete_${table}(1:${api_prefix}_${table}_match_spec_t match);
//::     else:
    i32 create_${table}(1: sai_attribute_list attr);
    i32 delete_${table}();

//::     #endif
//::   #endif
//:: #endfor
}

