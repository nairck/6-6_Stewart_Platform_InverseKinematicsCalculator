/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * stew_inverse_ws_terminate.c
 *
 * Code generation for function 'stew_inverse_ws_terminate'
 *
 */

/* Include files */
#include "stew_inverse_ws_terminate.h"
#include "_coder_stew_inverse_ws_mex.h"
#include "rt_nonfinite.h"
#include "stew_inverse_ws_data.h"

/* Function Definitions */
void stew_inverse_ws_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void stew_inverse_ws_terminate(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (stew_inverse_ws_terminate.c) */
