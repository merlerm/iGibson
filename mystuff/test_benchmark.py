import os
import json
import numpy as np
from PIL import Image

from unified_planning.shortcuts import *
from unified_planning.io import PDDLReader
up.shortcuts.get_env().credits_stream = None # Disable print of credits

import bddl
from igibson.action_primitives.fetch_robot_semantic_actions_env import FetchRobotSemanticActionEnv
from igibson.custom_utils import get_env_config, print_properties
import igibson.render_utils as render_utils

from planning_utils import print_symbolic_state, execute_plan, translate_str_to_dict

def main():
    ### Common setups ###
    pddl_dir = 'pddl' 
    domain_file = os.path.join(pddl_dir,'domain.pddl')
    reader = PDDLReader()
    
    easy_filename = 'easy_split_metadata.json'
    
    with open(easy_filename) as f:
        easy_split_metadata = json.load(f)
    
    benchmark_results = {}  # Initialize result container
    ### Task loop ###
    for entry in easy_split_metadata:
        task = easy_split_metadata[entry]["activity_name"]
        print("\n\n"+"-"*80)
        print(f"Executing task {task}")
        
        ### PDDL part ###
        pddl_problem_file = 'pddl/easy/'+entry
        
        # Parse problem and domain
        problem = reader.parse_problem(domain_file, pddl_problem_file)
            
        # Make a plan for the problem
        with OneshotPlanner(problem_kind=problem.kind) as planner:
            result = planner.solve(problem)
        
        # Check if planner found a plan
        if result.status == up.engines.PlanGenerationResultStatus.SOLVED_SATISFICING:
            print("Plan found.")
            # Prepare plan in the right format
            plan = [translate_str_to_dict(str(action)) for action in result.plan.actions]
            for action in plan:
                print(action)
        else:
            print("No plan found.")
            plan = []
    
        benchmark_results[task] = {}
        
        ### Sim_env part ###
        for task_instance, (scene_id, instance_id) in enumerate(easy_split_metadata[entry]["scene_instance_pairs"]):
            print(f"\nTask_instance: {task_instance} - scene_id: {scene_id} - instance_id: {instance_id}")
        
            # Init env
            sim_env = FetchRobotSemanticActionEnv(task, scene_id, instance_id, verbose=False)
            
            # Here goes the planning logic / benchmarking part
            plan_succeeded, plan_status = execute_plan(sim_env, plan, task, task_instance)
    
            # Save results in benchmark_results
            benchmark_results[task][task_instance] = {
                'scene_id': scene_id,
                'instance_id': instance_id,
                'plan_succeeded': plan_succeeded,
                'plan_status': plan_status
            }
            print(f"Plan succeeded: {plan_succeeded}.")
            print("Detailed plan breakdown: ", plan_status)
            
            # Shut down gracefully to avoid memory leaks
            sim_env.env.clean()

        
    # Save all benchmark results to disk
    results_file = 'benchmark_results.json'
    with open(results_file, 'w') as f:
        json.dump(benchmark_results, f, indent=2)
    
    print(f"\nBenchmarking complete. Results saved to {results_file}")

if __name__=="__main__":
    main()