/* Integration example only: requires a verified native RTOS loader first.
 * This object is not a firmware image and cannot be launched by Linux.
 * Keep the code resident for as long as its command is registered.
 */
#include "../yi4k_11052_internal.h"

static int userdemo(int argc, char **argv,
                    yi4k_shell_print_candidate_t print)
{
    (void)argv;
    if (!print) return -1;
    if (argc != 1) {
        print("Usage: t userdemo\n");
        return -1;
    }
    print("YI4K native extension: entered and returning\n");
    return 0;
}

/* Loader must call this after Shell pool/mutex initialization, from a
 * permissible task context, with the correct ARM ABI and executable memory.
 */
int yi4k_example_init(void)
{
    yi4k_t_register_candidate_t register_command =
        (yi4k_t_register_candidate_t)(uintptr_t)YI4K_ADDR_T_REGISTER;
    return register_command("userdemo", userdemo);
}
