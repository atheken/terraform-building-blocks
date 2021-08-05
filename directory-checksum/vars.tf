variable files {
    type = list(string)
    description = "A list of glob patterns from which to searcha and to generate a checksum."
}

variable base_path {
    description = "The base path from which to search for the files/directories listed above."
}