// Import the clipboard crate
extern crate clipboard;

// Use the ClipboardProvider and ClipboardContext traits from the clipboard crate
use clipboard::ClipboardProvider;
use clipboard::ClipboardContext;

fn main() {
    // Create a new ClipboardContext. This will be used for both copying and pasting.
    let mut ctx: ClipboardContext = ClipboardProvider::new().unwrap();

    // Define the text that we want to copy to the clipboard
    let text_to_copy = "Hello, clipboard!";

    // Copy the text to the clipboard
    ctx.set_contents(text_to_copy.to_owned()).unwrap();
    println!("Text copied to clipboard: {}", text_to_copy);

    // Attempt to paste the text from the clipboard
    let paste_result = ctx.get_contents();

    match paste_result {
        Ok(text) => println!("Text pasted from clipboard: {}", text),
        Err(e) => println!("Failed to paste text from clipboard: {}", e),
    }
}
