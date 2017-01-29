/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *STD_STANDARD;
char *IEEE_P_2717149903;
char *FMF_P_0731923793;
char *FMF_P_0581233933;
char *IEEE_P_1367372525;
char *IEEE_P_3620187407;
char *STD_TEXTIO;
char *IEEE_P_2592010699;
char *FMF_P_3101087109;
char *IEEE_P_3499444699;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    std_textio_init();
    ieee_p_2717149903_init();
    ieee_p_1367372525_init();
    fmf_p_3101087109_init();
    fmf_p_0731923793_init();
    fmf_p_0581233933_init();
    work_a_3854862945_3212880686_init();
    work_a_3982533956_1868357528_init();
    work_a_0043197572_1868357528_init();
    work_a_1371163244_2372691052_init();


    xsi_register_tops("work_a_1371163244_2372691052");

    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_2717149903 = xsi_get_engine_memory("ieee_p_2717149903");
    FMF_P_0731923793 = xsi_get_engine_memory("fmf_p_0731923793");
    FMF_P_0581233933 = xsi_get_engine_memory("fmf_p_0581233933");
    IEEE_P_1367372525 = xsi_get_engine_memory("ieee_p_1367372525");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    FMF_P_3101087109 = xsi_get_engine_memory("fmf_p_3101087109");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");

    return xsi_run_simulation(argc, argv);

}
