#!/usr/bin/env python3

import ipaddress
import phonenumbers
import re
import validators


# Validations
def auth_proto(line_count, auth_proto):
    if not re.search('(chap|mschap|pap)', auth_proto):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}, Please verify The Authentication Protocol.')
        print(f'   "{auth_proto}" did not match "chap|mschap|pap".  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def bgp_as(line_count, bgp_as):
    bgp_as=int(bgp_as)
    if not validators.between(bgp_as, min=1, max=4294967295):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. BGP AS "{bgp_as}" is invalid.')
        print(f'   A valid BGP AS is between 1 and 4294967295.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def email(line_count, email):
    if not validators.email(email, whitelist=None):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. Email address "{email}" is invalid.')
        print(f'   Please Validate the email and retry.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def hostname(line_count, name):
    pattern = re.compile('^[a-zA-Z0-9\\-]+$')
    if not re.search(pattern, name) and validators.length(name, min=1, max=63):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} is not a valid Hostname.')
        print(f'   Be sure you are not using the FQDN.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def inband(line_count, name, inb_ipv4, inb_gwv4):
    inb_check_ipv4 = ipaddress.IPv4Interface(inb_ipv4)
    inb_network_v4 = inb_check_ipv4.network
    if not ipaddress.IPv4Address(inb_gwv4) in ipaddress.IPv4Network(inb_network_v4):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} InBand Network does not Match Gateway Network.')
        print(f'   IPv4 Address "{inb_ipv4}"')
        print(f'   IPv4 Gateway "{inb_gwv4}".  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def inb_vlan(line_count, inb_vlan):
    if not validators.between(int(inb_vlan), min=2, max=4094):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. Inband Vlan "{inb_vlan}" is invalid.')
        print(f'   A valid Inband Vlan is between 2 and 4094.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def inb_vlan_exist(inb_vlan):
    if not inb_vlan:
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   The Inband VLAN must be defined before configuring management on all switches')
        print(f'   Please first add the Inband VLAN to the definiations.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def ipv4(line_count, ipv4):
    if not ipaddress.IPv4Address(ipv4):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. "{ipv4}" is not a valid IPv4 Address.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def log_level(line_count, log_loc, log_level):
    if log_loc == 'remote' or log_loc == 'local':
        if not re.match('(emergencies|alerts|critical|errors|warnings|notifications|information|debugging)', log_level):
            print(f'\n-----------------------------------------------------------------------------\n')
            print(f'   Error on Row {line_count}. Logging Level for "{log_loc}"  with "{log_level}"')
            print(f'   is not valid.  Logging Levels can be:')
            print(f'   [emergencies|alerts|critical|errors|warnings|notifications|information|debugging]')
            print(f'   Exiting....')
            print(f'\n-----------------------------------------------------------------------------\n')
            exit()
    elif log_loc == 'console':
        if not re.match('(emergencies|alerts|critical)', log_level):
            print(f'\n-----------------------------------------------------------------------------\n')
            print(f'   Error on Row {line_count}. Logging Level for "{log_loc}"  with "{log_level}"')
            print(f'   is not valid.  Logging Levels can be:')
            print(f'   [emergencies|alerts|critical].  Exiting....')
            print(f'\n-----------------------------------------------------------------------------\n')
            exit()

def login_domain(line_count, login_domain):
    if not validators.length(login_domain, min=1, max=10) and not re.fullmatch('^([a-zA-Z0-9\\_]+)$', login_domain):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Line {line_count}.  To Keep things simple for users, the login')
        print(f'   domain must be between 1 and 10 characters.  The only non alphanumeric')
        print(f'   character allowed is "_"; but it must not start with "_".')
        print(f'   "{login_domain}" did not meet these restrictions.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
    elif re.search('^[\\_]+', login_domain):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Line {line_count}.  To Keep things simple for users, the login')
        print(f'   domain must be between 1 and 10 characters.  The only non alphanumeric')
        print(f'   character allowed is "_"; but it must not start with "_".')
        print(f'   "{login_domain}" did not meet these restrictions.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def match_current_gw(line_count, current_inb_gwv4, inb_gwv4):
    if not current_inb_gwv4 == inb_gwv4:
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Line {line_count}.  Current inband = "{current_inb_gwv4}" and found')
        print(f'   "{inb_gwv4}".  The Inband Network should be the same on all APICs and Switches.')
        print(f'   A Different Gateway was found.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def mgmt_domain(line_count, mgmt_domain):
    if mgmt_domain == 'oob':
        mgmt_domain = 'oob-default'
    elif mgmt_domain == 'inband':
        mgmt_domain = 'inb-inb_epg'
    else:
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}, the Management Domain Should be inband or oob')
        print(f'   Please verify input information.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
    return mgmt_domain

def modules(line_count, name, switch_role, modules):
    module_count = 0
    if switch_role == 'leaf' and int(modules) == 1:
        module_count += 1
    elif switch_role == 'leaf':
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} module count is not valid.')
        print(f'   A Leaf can only have one module.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
    elif switch_role == 'spine' and int(modules) < 17:
        module_count += 1
    elif switch_role == 'spine':
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} module count is not valid.')
        print(f'   A Spine needs between 1 and 16 modules.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def node_id(line_count, node_id):
    if not validators.between(int(node_id), min=101, max=4001):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. node_id "{node_id}" is invalid.')
        print(f'   A valid Node ID is between 101 and 4000.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def node_id_apic(line_count, name, node_id):
    if not validators.between(int(node_id), min=1, max=7):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. APIC node_id "{node_id}" is invalid.')
        print(f'   A valid Node ID is between 1 and 7.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def node_type(line_count, name, node_type):
   if not re.search('^(remote-leaf-wan|unspecified)$', node_type):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} node_type "{node_type}" is not valid.')
        print(f'   Valid node_types are remote-leaf-wan or unspecified.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def oob(line_count, name, oob_ipv4, oob_gwv4):
    oob_check_ipv4 = ipaddress.IPv4Interface(oob_ipv4)
    oob_network_v4 = oob_check_ipv4.network
    if not ipaddress.IPv4Address(oob_gwv4) in ipaddress.IPv4Network(oob_network_v4):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} oob network does not match gateway network.')
        print(f'   IPv4 Address "{oob_ipv4}"')
        print(f'   IPv4 Gateway "{oob_gwv4}".  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def phone(line_count, phone_numbr):
    phone_number = phonenumbers.parse(phone_numbr, None)
    if not phonenumbers.is_possible_number(phone_number):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. Phone Number "{phone_number}" is invalid.  Make sure')
        print(f'   you are including the country code and the full phone number.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def pod_id(line_count, name, pod_id):
    if not validators.between(int(pod_id), min=1, max=12):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} pod_id {pod_id} is invalid.')
        print(f'   A valid Pod ID is between 1 and 12.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def port(line_count, port):
    if not validators.between(int(port), min=1, max=65535):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. Port {port} is invalid.')
        print(f'   A valid Port Number is between 1 and 65535.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def port_count(line_count, name, switch_role, port_count):
    if not re.search('^(32|36|48|64|96)$', port_count):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} port count of {port_count} is not valid.')
        print(f'   Valid port counts are 32, 36, 48, 64, 96.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def role(line_count, name, switch_role):
    if not re.search('^(leaf|spine)$', switch_role):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. {name} role {switch_role} is not valid.')
        print(f'   Valid switch_roles are leaf or spine, which are required by the')
        print(f'   script to determine resources to build.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def snmp_auth(line_count, auth_key, priv_key, priv_type):
    if not (priv_type == 'none' or priv_type == 'aes-128' or priv_type == 'des'):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'    Error on Row {line_count}. priv_type {priv_type} is not ')
        print(f'    [none|des|aes-128].  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
    if not priv_type == 'none':
        if not validators.length(priv_key, min=8):
            print(f'\n-----------------------------------------------------------------------------\n')
            print(f'   Error on Row {line_count}. priv_key does not ')
            print(f'   meet the minimum character count of 8.  Exiting....')
            print(f'\n-----------------------------------------------------------------------------\n')
            exit()

    if not validators.length(auth_key, min=8):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f"  Error on Row {line_count}. auth_key does not ")
        print(f"  meet the minimum character count of 8.  Exiting....")
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def snmp_string(line_count, snmp_name):
    if not (validators.length(snmp_name, min=1, max=32) and re.fullmatch('^([a-zA-Z0-9\\-\\_\\.]+)$', snmp_name)):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}. Community {snmp_name} is not valid.')
        print(f'   The community/username policy name can be a maximum of 32 characters in length.')
        print(f'   The name can contain only letters, numbers and the special characters of')
        print(f'   underscore (_), hyphen (-), or period (.). The name cannot contain')
        print(f'   the @ symbol.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def snmp_mgmt(line_count, mgmt_domain):
    if mgmt_domain == 'oob':
        mgmt_domain = 'Out-of-Band'
    elif mgmt_domain == 'inband':
        mgmt_domain = 'Inband'
    else:
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}, the Management Domain Should be inband or oob')
        print(f'   Please verify input information.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
    return mgmt_domain

def snmp_ver(line_count, snmp_vers):
    if not re.search('(v1|v2c|v3)', snmp_vers):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'  Error on Row {line_count}. SNMP Version {snmp_vers} is not valid.')
        print(f'  Valid SNMP versions are [v1|v2c|v3].  Exiting....\n')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def syslog_fac(line_count, facility):
    if not re.match("local[0-7]", facility):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}, Please verify Syslog Facility {facility}.\n')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def tacacs_key(line_count, tacacs_key):
    if not validators.length(tacacs_key, min=1, max=32):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}, The Shared Secret Length must be')
        print(f'   between 1 and 32 characters.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
    if re.search(r'[\ #]+', tacacs_key):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'  The Shared Secret cannot contain backslash, space or hashtag.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def tac_retry(line_count, retry):
    if not validators.length(retry, min=1, max=5):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}, The Retry shold be')
        print(f'   between 1 and 5.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()

def tac_timeout(line_count, tac_timeout):
    if not validators.length(int(tac_timeout), min=5, max=60) and not (int(tac_timeout) % 5 == 0):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   Error on Row {line_count}, Timeout should be between 5 and 60 and')
        print(f'   be a factor of 5.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()