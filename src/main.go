package main

import (
  "github.com/nfnt/resize"
  "image/jpeg"
  "log"
  "os"
)

func main() {
  file, err := os.Open("test.jpg")
  if err != nil { log.Fatal(err) }

  img, err := jpeg.Decode(file)
  if err != nil { log.Fatal(err) }
  file.Close()

  m := resize.Resize(0, 400, img, resize.Lanczos3)

  out, err := os.Create("test_resized.jpg")
  if err != nil { log.Fatal(err) }
  defer out.Close()

  jpeg.Encode(out, m, nil)
}
