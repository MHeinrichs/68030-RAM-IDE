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

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
extern char *IEEE_P_2592010699;
extern char *STD_STANDARD;

unsigned char ieee_p_2592010699_sub_1605435078_503743352(char *, unsigned char , unsigned char );
unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_2507238156_503743352(char *, unsigned char , unsigned char );


unsigned char fmf_p_3101087109_sub_3338352311_3716949792(char *t1, char *t2, char *t3)
{
    char t4[128];
    char t5[24];
    char t9[8];
    unsigned char t0;
    char *t6;
    char *t7;
    char *t8;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    int t17;
    int t18;
    int t19;
    int t20;
    int t21;
    int t22;
    int t23;
    int t24;
    int t25;
    int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    char *t30;
    unsigned char t31;
    unsigned char t32;
    char *t33;
    char *t34;

LAB0:    t6 = (t4 + 4U);
    t7 = ((IEEE_P_2592010699) + 3320);
    t8 = (t6 + 88U);
    *((char **)t8) = t7;
    t10 = (t6 + 56U);
    *((char **)t10) = t9;
    xsi_type_set_default_value(t7, t9, 0);
    t11 = (t6 + 80U);
    *((unsigned int *)t11) = 1U;
    t12 = (t5 + 4U);
    t13 = (t2 != 0);
    if (t13 == 1)
        goto LAB3;

LAB2:    t14 = (t5 + 12U);
    *((char **)t14) = t3;
    t15 = (t6 + 56U);
    t16 = *((char **)t15);
    t15 = (t16 + 0);
    *((unsigned char *)t15) = (unsigned char)2;
    t7 = (t3 + 8U);
    t17 = *((int *)t7);
    t8 = (t3 + 4U);
    t18 = *((int *)t8);
    t10 = (t3 + 0U);
    t19 = *((int *)t10);
    t20 = t19;
    t21 = t18;

LAB4:    t22 = (t21 * t17);
    t23 = (t20 * t17);
    if (t23 <= t22)
        goto LAB5;

LAB7:    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t13 = *((unsigned char *)t8);
    t0 = t13;

LAB1:    return t0;
LAB3:    *((char **)t12) = t2;
    goto LAB2;

LAB5:    t11 = (t6 + 56U);
    t15 = *((char **)t11);
    t13 = *((unsigned char *)t15);
    t11 = (t3 + 0U);
    t24 = *((int *)t11);
    t16 = (t3 + 8U);
    t25 = *((int *)t16);
    t26 = (t20 - t24);
    t27 = (t26 * t25);
    t28 = (1U * t27);
    t29 = (0 + t28);
    t30 = (t2 + t29);
    t31 = *((unsigned char *)t30);
    t32 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t13, t31);
    t33 = (t6 + 56U);
    t34 = *((char **)t33);
    t33 = (t34 + 0);
    *((unsigned char *)t33) = t32;

LAB6:    if (t20 == t21)
        goto LAB7;

LAB8:    t18 = (t20 + t17);
    t20 = t18;
    goto LAB4;

LAB9:;
}

char *fmf_p_3101087109_sub_3228335671_3716949792(char *t1, char *t2, char *t3, char *t4, unsigned char t5, int t6)
{
    char t7[248];
    char t8[32];
    char t12[8];
    char t20[16];
    char t61[16];
    char *t0;
    char *t9;
    char *t10;
    char *t11;
    char *t13;
    char *t14;
    char *t15;
    unsigned int t16;
    int t17;
    int t18;
    unsigned int t19;
    char *t21;
    unsigned int t22;
    int t23;
    char *t24;
    char *t25;
    int t26;
    unsigned int t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    unsigned char t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    int t41;
    int t42;
    int t43;
    int t44;
    int t45;
    int t46;
    int t47;
    int t48;
    int t49;
    unsigned int t50;
    unsigned int t51;
    char *t52;
    char *t53;
    int t54;
    int t55;
    char *t56;
    int t57;
    int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned char t62;

LAB0:    t9 = (t7 + 4U);
    t10 = ((STD_STANDARD) + 832);
    t11 = (t9 + 88U);
    *((char **)t11) = t10;
    t13 = (t9 + 56U);
    *((char **)t13) = t12;
    xsi_type_set_default_value(t10, t12, 0);
    t14 = (t9 + 80U);
    *((unsigned int *)t14) = 4U;
    t15 = (t4 + 12U);
    t16 = *((unsigned int *)t15);
    t17 = (t16 - 1);
    t18 = (0 - t17);
    t19 = (t18 * -1);
    t19 = (t19 + 1);
    t19 = (t19 * 1U);
    t21 = (t4 + 12U);
    t22 = *((unsigned int *)t21);
    t23 = (t22 - 1);
    t24 = (t20 + 0U);
    t25 = (t24 + 0U);
    *((int *)t25) = t23;
    t25 = (t24 + 4U);
    *((int *)t25) = 0;
    t25 = (t24 + 8U);
    *((int *)t25) = -1;
    t26 = (0 - t23);
    t27 = (t26 * -1);
    t27 = (t27 + 1);
    t25 = (t24 + 12U);
    *((unsigned int *)t25) = t27;
    t25 = (t7 + 124U);
    t28 = ((IEEE_P_2592010699) + 4024);
    t29 = (t25 + 88U);
    *((char **)t29) = t28;
    t30 = (char *)alloca(t19);
    t31 = (t25 + 56U);
    *((char **)t31) = t30;
    xsi_type_set_default_value(t28, t30, t20);
    t32 = (t25 + 64U);
    *((char **)t32) = t20;
    t33 = (t25 + 80U);
    *((unsigned int *)t33) = t19;
    t34 = (t8 + 4U);
    t35 = (t3 != 0);
    if (t35 == 1)
        goto LAB3;

LAB2:    t36 = (t8 + 12U);
    *((char **)t36) = t4;
    t37 = (t8 + 20U);
    *((unsigned char *)t37) = t5;
    t38 = (t8 + 21U);
    *((int *)t38) = t6;
    t39 = (t9 + 56U);
    t40 = *((char **)t39);
    t39 = (t40 + 0);
    *((int *)t39) = 0;

LAB4:    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    t17 = *((int *)t11);
    t35 = (t17 < t6);
    if (t35 != 0)
        goto LAB5;

LAB7:    t10 = (t25 + 56U);
    t11 = *((char **)t10);
    t10 = (t20 + 12U);
    t16 = *((unsigned int *)t10);
    t16 = (t16 * 1U);
    t0 = xsi_get_transient_memory(t16);
    memcpy(t0, t11, t16);
    t13 = (t20 + 0U);
    t17 = *((int *)t13);
    t14 = (t20 + 4U);
    t18 = *((int *)t14);
    t15 = (t20 + 8U);
    t23 = *((int *)t15);
    t21 = (t2 + 0U);
    t24 = (t21 + 0U);
    *((int *)t24) = t17;
    t24 = (t21 + 4U);
    *((int *)t24) = t18;
    t24 = (t21 + 8U);
    *((int *)t24) = t23;
    t26 = (t18 - t17);
    t19 = (t26 * t23);
    t19 = (t19 + 1);
    t24 = (t21 + 12U);
    *((unsigned int *)t24) = t19;

LAB1:    return t0;
LAB3:    *((char **)t34) = t3;
    goto LAB2;

LAB5:    t10 = (t4 + 0U);
    t18 = *((int *)t10);
    t13 = (t9 + 56U);
    t14 = *((char **)t13);
    t23 = *((int *)t14);
    t26 = (t23 + 7);
    t16 = (t18 - t26);
    t13 = (t9 + 56U);
    t15 = *((char **)t13);
    t41 = *((int *)t15);
    t13 = (t4 + 4U);
    t42 = *((int *)t13);
    t21 = (t4 + 8U);
    t43 = *((int *)t21);
    xsi_vhdl_check_range_of_slice(t18, t42, t43, t26, t41, -1);
    t19 = (t16 * 1U);
    t22 = (0 + t19);
    t24 = (t3 + t22);
    t28 = (t25 + 56U);
    t29 = *((char **)t28);
    t28 = (t20 + 0U);
    t44 = *((int *)t28);
    t31 = (t9 + 56U);
    t32 = *((char **)t31);
    t45 = *((int *)t32);
    t46 = (t45 + 7);
    t27 = (t44 - t46);
    t31 = (t9 + 56U);
    t33 = *((char **)t31);
    t47 = *((int *)t33);
    t31 = (t20 + 4U);
    t48 = *((int *)t31);
    t39 = (t20 + 8U);
    t49 = *((int *)t39);
    xsi_vhdl_check_range_of_slice(t44, t48, t49, t46, t47, -1);
    t50 = (t27 * 1U);
    t51 = (0 + t50);
    t40 = (t29 + t51);
    t52 = (t9 + 56U);
    t53 = *((char **)t52);
    t54 = *((int *)t53);
    t55 = (t54 + 7);
    t52 = (t9 + 56U);
    t56 = *((char **)t52);
    t57 = *((int *)t56);
    t58 = (t57 - t55);
    t59 = (t58 * -1);
    t59 = (t59 + 1);
    t60 = (1U * t59);
    memcpy(t40, t24, t60);
    t10 = (t4 + 0U);
    t17 = *((int *)t10);
    t11 = (t9 + 56U);
    t13 = *((char **)t11);
    t18 = *((int *)t13);
    t23 = (t18 + 7);
    t16 = (t17 - t23);
    t11 = (t9 + 56U);
    t14 = *((char **)t11);
    t26 = *((int *)t14);
    t11 = (t4 + 4U);
    t41 = *((int *)t11);
    t15 = (t4 + 8U);
    t42 = *((int *)t15);
    xsi_vhdl_check_range_of_slice(t17, t41, t42, t23, t26, -1);
    t19 = (t16 * 1U);
    t22 = (0 + t19);
    t21 = (t3 + t22);
    t24 = (t9 + 56U);
    t28 = *((char **)t24);
    t43 = *((int *)t28);
    t44 = (t43 + 7);
    t24 = (t9 + 56U);
    t29 = *((char **)t24);
    t45 = *((int *)t29);
    t24 = (t61 + 0U);
    t31 = (t24 + 0U);
    *((int *)t31) = t44;
    t31 = (t24 + 4U);
    *((int *)t31) = t45;
    t31 = (t24 + 8U);
    *((int *)t31) = -1;
    t46 = (t45 - t44);
    t27 = (t46 * -1);
    t27 = (t27 + 1);
    t31 = (t24 + 12U);
    *((unsigned int *)t31) = t27;
    t35 = fmf_p_3101087109_sub_3338352311_3716949792(t1, t21, t61);
    t62 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t35, t5);
    t31 = (t25 + 56U);
    t32 = *((char **)t31);
    t31 = (t9 + 56U);
    t33 = *((char **)t31);
    t47 = *((int *)t33);
    t48 = (t47 + 8);
    t31 = (t20 + 0U);
    t49 = *((int *)t31);
    t39 = (t20 + 8U);
    t54 = *((int *)t39);
    t55 = (t48 - t49);
    t27 = (t55 * t54);
    t40 = (t20 + 4U);
    t57 = *((int *)t40);
    xsi_vhdl_check_range_of_index(t49, t57, t54, t48);
    t50 = (1U * t27);
    t51 = (0 + t50);
    t52 = (t32 + t51);
    *((unsigned char *)t52) = t62;
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    t17 = *((int *)t11);
    t18 = (t17 + 9);
    t10 = (t9 + 56U);
    t13 = *((char **)t10);
    t10 = (t13 + 0);
    *((int *)t10) = t18;
    goto LAB4;

LAB6:;
LAB8:;
}

unsigned char fmf_p_3101087109_sub_1676230124_3716949792(char *t1, char *t2, char *t3, unsigned char t4, int t5)
{
    char t6[248];
    char t7[32];
    char t11[8];
    char t17[8];
    char t38[16];
    unsigned char t0;
    char *t8;
    char *t9;
    char *t10;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t18;
    char *t19;
    char *t20;
    unsigned char t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    int t27;
    unsigned char t28;
    int t29;
    int t30;
    int t31;
    unsigned int t32;
    int t33;
    int t34;
    int t35;
    unsigned int t36;
    unsigned int t37;
    int t39;
    int t40;
    char *t41;
    int t42;
    char *t43;
    int t44;
    unsigned int t45;
    unsigned char t46;
    unsigned char t47;
    unsigned char t48;
    unsigned char t49;
    char *t50;

LAB0:    t8 = (t6 + 4U);
    t9 = ((STD_STANDARD) + 832);
    t10 = (t8 + 88U);
    *((char **)t10) = t9;
    t12 = (t8 + 56U);
    *((char **)t12) = t11;
    xsi_type_set_default_value(t9, t11, 0);
    t13 = (t8 + 80U);
    *((unsigned int *)t13) = 4U;
    t14 = (t6 + 124U);
    t15 = ((IEEE_P_2592010699) + 3320);
    t16 = (t14 + 88U);
    *((char **)t16) = t15;
    t18 = (t14 + 56U);
    *((char **)t18) = t17;
    xsi_type_set_default_value(t15, t17, 0);
    t19 = (t14 + 80U);
    *((unsigned int *)t19) = 1U;
    t20 = (t7 + 4U);
    t21 = (t2 != 0);
    if (t21 == 1)
        goto LAB3;

LAB2:    t22 = (t7 + 12U);
    *((char **)t22) = t3;
    t23 = (t7 + 20U);
    *((unsigned char *)t23) = t4;
    t24 = (t7 + 21U);
    *((int *)t24) = t5;
    t25 = (t8 + 56U);
    t26 = *((char **)t25);
    t25 = (t26 + 0);
    *((int *)t25) = 0;
    t9 = (t14 + 56U);
    t10 = *((char **)t9);
    t9 = (t10 + 0);
    *((unsigned char *)t9) = (unsigned char)3;

LAB4:    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t27 = *((int *)t10);
    t21 = (t27 < t5);
    if (t21 != 0)
        goto LAB5;

LAB7:    t9 = (t14 + 56U);
    t10 = *((char **)t9);
    t21 = *((unsigned char *)t10);
    t0 = t21;

LAB1:    return t0;
LAB3:    *((char **)t20) = t2;
    goto LAB2;

LAB5:    t9 = (t14 + 56U);
    t12 = *((char **)t9);
    t28 = *((unsigned char *)t12);
    t9 = (t3 + 0U);
    t29 = *((int *)t9);
    t13 = (t8 + 56U);
    t15 = *((char **)t13);
    t30 = *((int *)t15);
    t31 = (t30 + 8);
    t32 = (t29 - t31);
    t13 = (t8 + 56U);
    t16 = *((char **)t13);
    t33 = *((int *)t16);
    t13 = (t3 + 4U);
    t34 = *((int *)t13);
    t18 = (t3 + 8U);
    t35 = *((int *)t18);
    xsi_vhdl_check_range_of_slice(t29, t34, t35, t31, t33, -1);
    t36 = (t32 * 1U);
    t37 = (0 + t36);
    t19 = (t2 + t37);
    t25 = (t8 + 56U);
    t26 = *((char **)t25);
    t39 = *((int *)t26);
    t40 = (t39 + 8);
    t25 = (t8 + 56U);
    t41 = *((char **)t25);
    t42 = *((int *)t41);
    t25 = (t38 + 0U);
    t43 = (t25 + 0U);
    *((int *)t43) = t40;
    t43 = (t25 + 4U);
    *((int *)t43) = t42;
    t43 = (t25 + 8U);
    *((int *)t43) = -1;
    t44 = (t42 - t40);
    t45 = (t44 * -1);
    t45 = (t45 + 1);
    t43 = (t25 + 12U);
    *((unsigned int *)t43) = t45;
    t46 = fmf_p_3101087109_sub_3338352311_3716949792(t1, t19, t38);
    t47 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t46, t4);
    t48 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t47);
    t49 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t28, t48);
    t43 = (t14 + 56U);
    t50 = *((char **)t43);
    t43 = (t50 + 0);
    *((unsigned char *)t43) = t49;
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t27 = *((int *)t10);
    t29 = (t27 + 9);
    t9 = (t8 + 56U);
    t12 = *((char **)t9);
    t9 = (t12 + 0);
    *((int *)t9) = t29;
    goto LAB4;

LAB6:;
LAB8:;
}

unsigned char fmf_p_3101087109_sub_2502954956_3716949792(char *t1, unsigned char t2)
{
    char t4[8];
    unsigned char t0;
    char *t5;
    char *t6;
    char *t7;
    int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned char t12;

LAB0:    t5 = (t4 + 4U);
    *((unsigned char *)t5) = t2;
    t6 = (t1 + 2368U);
    t7 = *((char **)t6);
    t8 = (t2 - 0);
    t9 = (t8 * 1);
    t10 = (1U * t9);
    t11 = (0 + t10);
    t6 = (t7 + t11);
    t12 = *((unsigned char *)t6);
    t0 = t12;

LAB1:    return t0;
LAB2:;
}


extern void fmf_p_3101087109_init()
{
	static char *se[] = {(void *)fmf_p_3101087109_sub_3338352311_3716949792,(void *)fmf_p_3101087109_sub_3228335671_3716949792,(void *)fmf_p_3101087109_sub_1676230124_3716949792,(void *)fmf_p_3101087109_sub_2502954956_3716949792};
	xsi_register_didat("fmf_p_3101087109", "isim/SDRAM_IDE_TB_isim_beh.exe.sim/fmf/p_3101087109.didat");
	xsi_register_subprogram_executes(se);
}
