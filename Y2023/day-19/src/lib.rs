use regex::Regex;
use std::collections::HashMap;
use Output::*;
use Rule::*;

#[derive(Hash, Eq, PartialEq, Debug, Clone, Copy)]
enum Variable {
    X,
    M,
    A,
    S,
}

#[derive(Debug, Clone, Copy)]
struct VariableRanges {
    x: Range,
    m: Range,
    a: Range,
    s: Range,
}

impl VariableRanges {
    fn init() -> VariableRanges {
        VariableRanges {
            x: Range::init(),
            m: Range::init(),
            a: Range::init(),
            s: Range::init(),
        }
    }

    fn count(&self) -> u64 {
        return self.x.count() * self.m.count() * self.a.count() * self.s.count();
    }

    fn setting(&self, variable: &Variable, value: Range) -> VariableRanges {
        return VariableRanges {
            x: if variable == &Variable::X {
                value
            } else {
                self.x
            },
            m: if variable == &Variable::M {
                value
            } else {
                self.m
            },
            a: if variable == &Variable::A {
                value
            } else {
                self.a
            },
            s: if variable == &Variable::S {
                value
            } else {
                self.s
            },
        };
    }

    fn get(&self, variable: &Variable) -> Range {
        match variable {
            Variable::X => self.x,
            Variable::M => self.m,
            Variable::A => self.a,
            Variable::S => self.s,
        }
    }
}

#[derive(Debug, Clone, Copy)]
struct Range {
    start: u64,
    end: u64,
}

impl Range {
    fn init() -> Range {
        Range {
            start: 1,
            end: 4000,
        }
    }

    fn count(&self) -> u64 {
        return self.end - self.start + 1;
    }

    fn split(&self, operator: Operator, comparator: u64) -> (Range, Range) {
        match operator {
            Operator::LessThan => {
                let left = Range {
                    start: self.start,
                    end: comparator - 1,
                };
                let right = Range {
                    start: comparator,
                    end: self.end,
                };
                return (right, left);
            }
            Operator::GreaterThan => {
                let left = Range {
                    start: self.start,
                    end: comparator,
                };
                let right = Range {
                    start: comparator + 1,
                    end: self.end,
                };
                return (left, right);
            }
        }
    }
}

#[derive(Debug, Clone)]
enum Rule {
    Variable(Output),
    Operation(Operation),
}

#[derive(Debug, Clone)]
struct Operation {
    variable: Variable,
    operator: Operator,
    comparator: u64,
    output: Output,
}

#[derive(Debug, Clone, Copy)]
enum Operator {
    GreaterThan,
    LessThan,
}

#[derive(Debug, Clone)]
enum Output {
    Approve,
    Reject,
    Reference(String),
}

impl Output {
    fn from(string: &str) -> Output {
        match string {
            "A" => Output::Approve,
            "R" => Output::Reject,
            _ => Output::Reference(string.to_string()),
        }
    }
}

pub fn solve_part1(input: &str) -> String {
    let (workflows, inputs) = parse(input);
    let mut result = 0;
    let workflow = &workflows[&"in".to_string()];
    for input in inputs {
        if solve(workflow, &workflows, &input) {
            result += input.values().sum::<u64>();
        }
    }
    return result.to_string();
}

fn solve(
    workflow: &Vec<Rule>,
    workflows: &HashMap<String, Vec<Rule>>,
    variables: &HashMap<Variable, u64>,
) -> bool {
    let rule = workflow.first().unwrap();
    match rule {
        Operation(operation) => {
            let variable_value = variables[&operation.variable];
            if !compare(variable_value, operation.comparator, operation.operator) {
                return solve(&workflow[1..].to_vec(), workflows, variables);
            }
            return match &operation.output {
                Reference(id) => solve(&workflows[id], workflows, variables),
                Approve => true,
                Reject => false,
            };
        }
        Variable(Reference(id)) => solve(&workflows[id], workflows, variables),
        Variable(Approve) => true,
        Variable(Reject) => false,
    }
}

fn compare(a: u64, b: u64, operator: Operator) -> bool {
    match operator {
        Operator::GreaterThan => return a > b,
        Operator::LessThan => return a < b,
    }
}

pub fn solve_part2(input: &str) -> String {
    let (workflows, _) = parse(input);
    let workflow = &workflows[&"in".to_string()];
    return count_possibilities(workflow, VariableRanges::init(), &workflows).to_string();
}

fn count_possibilities(
    workflow: &Vec<Rule>,
    ranges: VariableRanges,
    workflows: &HashMap<String, Vec<Rule>>,
) -> u64 {
    let rule = workflow.first().unwrap();
    match rule {
        Operation(operation) => {
            let range = ranges.get(&operation.variable);
            let (loser, winner) = range.split(operation.operator, operation.comparator);
            let recursion = count_possibilities(
                &workflow[1..].to_vec(),
                ranges.setting(&operation.variable, loser),
                workflows,
            );
            return recursion
                + match &operation.output {
                    Reference(id) => count_possibilities(
                        &workflows[id],
                        ranges.setting(&operation.variable, winner),
                        workflows,
                    ),
                    Approve => ranges.setting(&operation.variable, winner).count(),
                    Reject => 0,
                };
        }
        Variable(Reference(id)) => count_possibilities(&workflows[id], ranges, workflows),
        Variable(Approve) => ranges.count(),
        Variable(Reject) => 0,
    }
}

fn parse(input: &str) -> (HashMap<String, Vec<Rule>>, Vec<HashMap<Variable, u64>>) {
    let parts = input.split("\n\n").collect::<Vec<_>>();
    let rules = parts[0]
        .lines()
        .map(parse_workflow)
        .collect::<HashMap<String, Vec<Rule>>>();
    let inputs = parts[1]
        .lines()
        .map(parse_variables_line)
        .collect::<Vec<_>>();
    return (rules, inputs);
}

fn parse_workflow(line: &str) -> (String, Vec<Rule>) {
    let regex = Regex::new(r"([a-z]+)\{([a-zA-Z0-9<>:,]+)\}").unwrap();
    let captures = regex.captures(line).unwrap();
    let key = captures[1].to_string();
    let rules = captures[2].split(",").map(parse_workflow_rules).collect();
    return (key, rules);
}

fn parse_workflow_rules(line: &str) -> Rule {
    let regex = Regex::new(r"([xmas])([<>])(\d+):([a-zA-Z]+)").unwrap();
    if let Some(captures) = regex.captures(line) {
        return Rule::Operation(parse_workflow_rule(
            &captures[1],
            &captures[2],
            &captures[3],
            &captures[4],
        ));
    }
    return Rule::Variable(Output::from(line));
}

fn parse_workflow_rule(variable: &str, operator: &str, value: &str, output: &str) -> Operation {
    let variable = match variable {
        "x" => Variable::X,
        "m" => Variable::M,
        "a" => Variable::A,
        "s" => Variable::S,
        _ => panic!(),
    };
    let comparator = value.parse::<u64>().unwrap();
    let output = Output::from(output);
    let operator = match operator {
        "<" => Operator::LessThan,
        ">" => Operator::GreaterThan,
        _ => panic!(),
    };
    return Operation {
        variable,
        operator,
        comparator,
        output,
    };
}

fn parse_variables_line(line: &str) -> HashMap<Variable, u64> {
    let regex = Regex::new(r"\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)\}").unwrap();
    let captures = regex.captures(line).unwrap();
    return HashMap::from([
        (Variable::X, captures[1].parse().unwrap()),
        (Variable::M, captures[2].parse().unwrap()),
        (Variable::A, captures[3].parse().unwrap()),
        (Variable::S, captures[4].parse().unwrap()),
    ]);
}
