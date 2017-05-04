Fixed length sequence validation:
  based on: strictyaml
  description: |
    Sequences can have multiple different types of within them
    provided they are of a fixed length.
  preconditions:
    files:
      valid_sequence.yaml: |
        - 1
        - a
        - 2.5
      invalid_sequence_1.yaml: |
        a: 1
        b: 2
        c: 3
      invalid_sequence_2.yaml: |
        - 2
        - a
        - a:
          - 1
          - 2
      invalid_sequence_3.yaml: |
        - 1
        - a
  scenario:
    - Run command: |
        from strictyaml import FixedSeq, Str, Int, Float, YAMLValidationError, load

        schema = FixedSeq([Int(), Str(), Float()])

    - Assert True: load(valid_sequence, schema) == [1, "a", 2.5, ]

    - Assert Exception:
        command: load(invalid_sequence_1, schema)
        exception: |
          when expecting a sequence of 3 elements
            in "<unicode string>", line 1, column 1:
              a: '1'
               ^ (line: 1)
          found non-sequence
            in "<unicode string>", line 3, column 1:
              c: '3'
              ^ (line: 3)

    - Assert Exception:
        command: load(invalid_sequence_2, schema)
        exception: |
          when expecting a float
            in "<unicode string>", line 3, column 1:
              - a:
              ^ (line: 3)
          found mapping/sequence
            in "<unicode string>", line 5, column 1:
                - '2'
              ^ (line: 5)

    - Assert Exception:
        command: load(invalid_sequence_3, schema)
        exception: |
          when expecting a sequence of 3 elements
            in "<unicode string>", line 1, column 1:
              - '1'
               ^ (line: 1)
          found a sequence of 2 elements
            in "<unicode string>", line 2, column 1:
              - a
              ^ (line: 2)
