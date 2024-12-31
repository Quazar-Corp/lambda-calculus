open Frontend

module Semantic_test = struct
  module Setup = struct
    open Semantic

    let expression_formatter ppf expression =
      Format.fprintf ppf "%s" (Semantic.expression_to_string expression)

    let expression_testable =
      Alcotest.testable expression_formatter Semantic.equal_expression

    let identity = Abstraction ("x", Variable "x")
  end

  module Property = struct
    let identity_should_eval_to_body () =
      Alcotest.(check Setup.expression_testable)
        "Identity function should be evaluated to the body" Setup.identity
        (Semantic.eval [] Setup.identity)
  end
end

let () =
  let open Alcotest in
  run "Semantic analysis"
    [
      ( "Evaluation",
        [
          test_case "Identity function" `Quick
            Semantic_test.Property.identity_should_eval_to_body;
        ] );
    ]
