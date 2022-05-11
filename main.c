#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <unistd.h>
#include <uthash.h>
#include "termbox2.h"
#include "mlbuf.h"
#include "mle.h"

editor_t _editor;

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    uscript_t* script;
    editor_t _editor;

    // Initialize editor
    memset(&_editor, 0, sizeof(editor_t));
    editor_init(&_editor, 0, NULL);

    script = uscript_run_no_file(&_editor, data, size);

    // Cleanup
    uscript_destroy(script);
    editor_deinit(&_editor);
}

//int main(int argc, char **argv) {
//    memset(&_editor, 0, sizeof(editor_t));
//    setlocale(LC_ALL, "");
//    if (editor_init(&_editor, argc, argv) == MLE_OK) {
//        if (!_editor.headless_mode) {
//            tb_init();
//            tb_select_input_mode(TB_INPUT_ALT);
//        }
//        editor_run(&_editor);
//        if (_editor.headless_mode && _editor.active_edit) {
//            buffer_write_to_fd(_editor.active_edit->buffer, STDOUT_FILENO, NULL);
//        }
//        if (_editor.debug_dump_state_on_exit) {
//            editor_debug_dump(&_editor, stderr);
//        }
//        editor_deinit(&_editor);
//        if (!_editor.headless_mode) {
//            tb_shutdown();
//        }
//    } else {
//        editor_deinit(&_editor);
//    }
//    return _editor.exit_code;
//}
