#!/usr/bin/env python3

import openpyxl
import ipaddress
import json
import phonenumbers
import os, re, sys, traceback, validators
import tf_templates
import validating
from datetime import datetime, timedelta
from openpyxl import load_workbook,workbook
from os import path

excel_workbook = sys.argv[1]
try:
    if os.path.isfile(excel_workbook):
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   {excel_workbook} exists.  Beginning Script Execution...')
        print(f'\n-----------------------------------------------------------------------------\n')
    else:
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   {excel_workbook} does not exist.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
except IOError:
    print(f'\n-----------------------------------------------------------------------------\n')
    print(f'   {excel_workbook} does not exist.  Exiting....')
    print(f'\n-----------------------------------------------------------------------------\n')
    exit()
wb = load_workbook(excel_workbook)
ws1 = wb['Tenant']
ws2 = wb['VRF']
ws3 = wb['L3Out']
ws4 = wb['Bridge Domain']
ws5 = wb['Subnet']
ws6 = wb['DHCP Relay']
ws7 = wb['App and EPGs']
ws8 = wb['Access Interfaces']

# Create Resource configuration Files to store user input Data
# resources_user_import_tntv.tf will include Tenant and VRF Definitions
# resources_user_import_bds.tf will include Bridge Domains, DHCP Relay and Subnets
# resources_user_import_epgs.tf will include Apps and EPGs
# resources_user_import_intf.tf
file_apps = './tenant/variables_user_import_apps.tf'
file_bds = './tenant/variables_user_import_bds.tf'
file_epgs = './tenant/variables_user_import_epgs.tf'
file_interfaces = './tenant/variables_user_import_access_interfaces.tf'
file_tenants = './tenant/resources_user_input_Tenants.tf'
file_vrfs = './tenant/resources_user_input_VRFs.tf'
wr_apps = open(file_apps, 'w')
wr_epgs = open(file_epgs, 'w')
wr_bds = open(file_bds, 'w')
wr_interfaces = open(file_interfaces, 'w')
wr_tenants = open(file_tenants, 'w')
wr_vrfs = open(file_vrfs, 'w')
wr_apps.write('# This File will include Applications\n\nvariable \"user_apps\" {\n\tdefault = {\n')
wr_epgs.write('# This File will include EPGs\n\nvariable \"user_epgs\" {\n\tdefault = {\n')
wr_bds.write('# This File will include Bridge Domains\n\nvariable \"user_bds\" {\n\tdefault = {\n')
wr_interfaces.write('# This File will include Access Interfaces\n\nvariable \"user_intfs\" {\n\tdefault = {\n')
wr_tenants.write("# This File will include Tenants\n\n")
wr_vrfs.write("# This File will include VRFs\n\n")

def resource_tenant(tenant_name, tenant_descr):
    try:
        # Validate Tenant Name
        validating.name_rule(line_count, tenant_name)
    except Exception as err:
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   {SystemExit(err)}')
        print(f'   Error on Row {line_count}.  Please verify input information.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
    
    # Build Template and Populate Template
    wr_file = wr_tenants
    resource_type = 'aci_tenant'
    resource_desc = tenant_name
    attr_1 = 'name        = "%s"' % (tenant_name)
    attr_2 = 'description = "%s"' % (tenant_descr)
    tf_templates.aci_terraform_attr2(resource_type, resource_desc, attr_1, attr_2, wr_file)


def resource_vrf(tenant_name, vrf_name, vrf_desc, fltr_type):
    try:
        # Validate Tenant and VRF Name
        validating.name_rule(line_count, tenant_name)
        validating.name_rule(line_count, vrf_name)
    except Exception as err:
        print(f'\n-----------------------------------------------------------------------------\n')
        print(f'   {SystemExit(err)}')
        print(f'   Error on Row {line_count}.  Please verify input information.  Exiting....')
        print(f'\n-----------------------------------------------------------------------------\n')
        exit()
    
    # Build Template and Populate Template
    wr_file = wr_vrfs

    # Add VRF to Resource File
    resource_type = 'aci_vrf'
    resource_desc = '%s' % (vrf_name)
    attr_1 = 'tenant_dn							= "/uni/tn-%s"' % (tenant_name)
    attr_2 = 'name        						= "%s"' % (vrf_name)
    attr_3 = 'bd_enforced_enable				    = "enabled"'
    attr_4 = 'ip_data_plane_learning			    = "enabled"'
    attr_5 = 'pc_enf_pref						    = "enforced"'
    attr_6 = 'pc_enf_dir						    = "ingress"'
    attr_7 = 'relation_fv_rs_ctx_mon_pol		    = "/uni/tn-common/monepg-default"'
    attr_8 = 'relation_fv_rs_ctx_to_ep_ret		= "/uni/tn-common/epRPol-default"'
    attr_9 = 'relation_fv_rs_vrf_validation_pol	= "/uni/tn-common/vrfvalidationpol-default"'
    tf_templates.aci_terraform_attr9(resource_type, resource_desc, attr_1, attr_2,  attr_3, attr_4, attr_5, attr_6,  attr_7, attr_8, attr_9, wr_file)

    resource_type = 'aci_any'
    resource_desc = "%s_pc" % (vrf_name)
    attr_1 = 'vrf_dn 				        = "/uni/tn-%s/ctx-%s"' % (tenant_name, vrf_name)
    attr_2 = 'description 				= "%s"' % (vrf_desc)
    if fltr_type == 'pg':
        attr_3 = 'pref_gr_memb                = "enabled"'
        tf_templates.aci_terraform_attr3(resource_type, resource_desc, attr_1, attr_2,  attr_3, wr_file)
    elif fltr_type == 'vzAny':
        attr_3 = 'match_t      				= "AtleastOne"'
        attr_4 = 'relation_vz_rs_any_to_cons	= "uni/tn-common/brc-default"'
        attr_5 = 'relation_vz_rs_any_to_prov	= "uni/tn-common/brc-default"'
        tf_templates.aci_terraform_attr5(resource_type, resource_desc, attr_1, attr_2,  attr_3, attr_4, attr_5, wr_file)


line_count = 0
# Loop Through User Defined Tenants in Worksheet "Tenant"
for r in ws1.rows:
    if any(r):        
        type = str(r[0].value)
        if type == 'tnt_add':
            tenant_name = str(r[1].value)
            tenant_desc = str(r[2].value)

            # Create Resource Records for Tenant
            resource_tenant(tenant_name, tenant_desc)
            line_count += 1
        elif type == 'tnt_vrf':
            tenant_name = str(r[1].value)
            tenant_desc = str(r[2].value)
            vrf_name = '{}_vrf'.format(tenant_name)
            vrf_desc = str(r[5].value)
            fltr_type = str(r[8].value)

            # Create Resource Records for Tenant and VRF
            resource_tenant(tenant_name, tenant_desc)
            tnt_name = 'common'
            resource_vrf(tnt_name, vrf_name, vrf_desc, fltr_type)
            line_count += 1
        else:
            line_count += 1
    else:
        line_count += 1

line_count = 0
# Loop Through User Defined VRFs in Worksheet "VRF"
for r in ws2.rows:
    if any(r):        
        type = str(r[0].value)
        if type == 'vrf_add':
            tenant_name = str(r[1].value)
            vrf_name = str(r[2].value)
            vrf_desc = str(r[3].value)
            fltr_type = str(r[6].value)

            # Create Resource Records for VRF
            resource_vrf(tnt_name, vrf_name, vrf_desc, fltr_type)
            line_count += 1
        else:
            line_count += 1
    else:
        line_count += 1

line_count = 0
# Loop Through User Defined L3Outs in Worksheet "L3Out"
for r in ws2.rows:
    if any(r):        
        type = str(r[0].value)
        if type == 'l3out':
            l3_host_tnt = str(r[1].value)
            l3out_tenant = str(r[2].value)
            l3_domain = str(r[3].value)
            routing_pt = str(r[4].value)
            intf_type = str(r[5].value)

            # Create Resource Records for VRF
            resource_vrf(tnt_name, vrf_name, vrf_desc, fltr_type)
            line_count += 1
        else:
            line_count += 1
    else:
        line_count += 1

# Close out the Open Files
#csv_file.close()
wr_apps.write("\t}\n}")
wr_apps.close()
wr_epgs.write("\t}\n}")
wr_epgs.close()
wr_bds.write("\t}\n}")
wr_bds.close()
wr_interfaces.write("\t}\n}")
wr_interfaces.close()
wr_tenants.close()
wr_vrfs.close()


#End Script
print(f'\n-----------------------------------------------------------------------------\n')
print(f'   Completed Running Script.  Exiting....')
print(f'\n-----------------------------------------------------------------------------\n')
exit()