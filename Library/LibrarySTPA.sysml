library package LibrarySTPA {
    private import ScalarValues::*;
    private import Views::*;
    doc
    /* This library contains the System-Theoretic Process Analysis (STPA) language extension for SysML v2. 
     * The package is structured according to the four steps of the STPA:
     * 1. Defining the purpose of the analysis
     * 2. Modelling the control structure
     * 3. Identifying unsafe control control actions
     * 4. Identifying loss scenarios
     * In addition, two package are included that help to improve usability of the library:
     * 5. Defines MetaData for relevant STPA types
     * 6. Defines Views and Viewpoints for STPA activities
     */
    package DefineAnalysisPurpose {
        doc
        /* This package contains the elements related to the first step of the STPA. 
         * The first step covers the definition of losses and hazards
         * as the baseline for the analysis.
         */
        occurrence def Loss {
            doc
            /* Definition:
             * Represent the act or fact of being unable to keep or
             * maintain something valued by a stakeholder.
             * Losses may include harm to people, property losses,
             * environmental losses, mission losses, 
             * loss of system performance, reputation losses, or 
             * any other relevant losses determined by the stakeholders. 
             *
             * Model-Based Composition:
             * Loss = <StateOfConcern> & <StakeholderConcern>
             *
             * Example:
             * <Loss of> <life>.
             */
            attribute stateOfConcern : StatesOfConcern;
            ref concern stakeholderConcern;
        }
        occurrence losses [*] : Loss;
        enum def StatesOfConcern {
            'Loss of';
            'Occurrence of';
        }
        occurrence def Hazard {
            doc
            /* Definition:
             * Represents a system state or set of conditions that together with a 
             * particular set of worst-case environmental conditions, will lead to a loss.
             *
             * Model-Based Composition:
             * Hazard = <System> & <UnsafeCondition> & [Losses]
             *
             * Example:
             * <Automated vehicle> <loses control> resulting in [loss of life].
             */
            ref part systemRef [1];
            attribute unsafeCondition [1] : String;
            ref occurrence lossesRef [1..*] : Loss;
        }
        occurrence hazards [*] : Hazard;
    }
    package ModelControlStructure {
        doc
        /* This package contains the elements related to the second step of the STPA. 
         * The second step covers the modelling of the control structure.
         */
        part def ControlStructure {
            doc
            /* Definition:
             * Represents a hierarchical structure that models the layers of control in a system. 
             * Each level imposes constraints on the activities of the levels below, and each level may receive feedback or other information about the levels below. 
             * Control structures model the relationships and interactions between controllers, controlled processes, control actions, feedback, and other information.
             *
             * Example:
             * A control oriented model showing the interactions of an automated vehicle with related systems and people.
             */
            ref part actuatorsRef [*] : Actuator;
            ref part sensorsRef [*] : Sensor;
            ref part processesRef [*] : Process;
            ref part controllersRef [*] : Controller;
            ref flow controlActionsRef [*] : ControlAction;
            ref flow feedbacksRef [*] : Feedback;
            ref flow otherInformationsRef [*] : OtherInformation;
        }
        part controlStructures [*] : ControlStructure;
        part def Controller {
            doc
            /* Definition:
             * Represents an entity that forms beliefs, makes decisions, and provides control actions to achieve or maintain a state or goal.
             *
             * Example:
             * ControlElectronics of an automated vehicle.
             */
            ref part processBeliefs [*] : ProcessModel;
        }
        part controllers [*] : Controller;
        part def HumanController :> Controller {
            doc
            /* Definition:
             * Represents a human that takes over controller related activities.
             *
             * Example:
             * Teleoperator which makes decisions about the operation of an automated vehicle.
             */
            ref part mentalBeliefs [*] : MentalModel;
        }
        part humanControllers [*] : HumanController;
        part def ProcessModel {
            doc
            /* Definition:
             * A representation of a controller's internal beliefs used to make decisions. 
             * Process models may include beliefs about the controlled process or other relevant aspects of the system or the environment. 
             * Process models may be partly updated by feedback used to observe the controlled process.
             *
             * Example:
             * Navigation map used by the ControlElectronics of the automated vehicle. 
             */
        }
        part processModels [*] : ProcessModel;
        part def MentalModel :> ProcessModel {
            doc
            /* Definition:
             * A representation of someone's thought process about how something works in the real world. 
             * It describes the surrounding world, the relationships between its various parts, and a person's intuitive perception about their own acts and consequences.
             *
             * Example:
             * Teleoperator's idea of which vehicle he supervises.
             */
        }
        part mentalModels [*] : MentalModel;
        part def Actuator {
            doc
            /* Definition:
             * Represents an entity in the control structure which executes a control action by a controller.
             *
             * Example:
             * Brake of the automated vehicle.
             */
        }
        part actuators [*] : Actuator;
        part def Sensor {
            doc
            /* Definition:
             * Represents an entitiy in the control structure which provides feedback to a controller.
             *
             * Example:
             * Perception system of automated vehicle.
             */
        }
        part sensors [*] : Sensor;
        part def Process {
            doc
            /* Definition:
             * Represents any process, such as a physical process, a virtual process, a controller, or other processes 
             * that receives control actions from and provides feedback to higher-level controllers in a control structure.  
             * Processes with specified restrictions that bound the performance of its intended behavior.
             *
             * Example:
             * Movement of the automated vehicle.
             */
        }
        part processes [*] : Process;
        flow def ControlAction {
            doc
            /* Definition:
             * Represents a command, instruction, or other directive 
             * provided by a controller to control a process and achieve goals.
             *
             * Example:
             * Teleopartor command.
             */
            end actionSource;
            end actionTarget;
        }
        flow controlActions [*] : ControlAction;
        flow def Feedback {
            doc
            /* Definition:
             * Represents a value, measurement or other information provided to a controller to achieve its goals.
             *
             * Example:
             * Camera images.
             */
            end feedbackSource;
            end feedbackTarget;
        }
        flow feedbacks [*] : Feedback;
        flow def OtherInformation {
            doc
            /* Definition:
             * Represents values that may come from other processes, other controllers, or other sources in the system or the environment.
             *
             * Example:
             * Sunlight from the environment.
             */
            end informationSource;
            end informationTarget;
        }
        flow otherInformation [*] : OtherInformation;
    }
    package IdentifyUCAs {
        doc
        /* This package contains the elements related to the third step of the STPA. 
         * The third step covers the identification of unsafe control actions.
         */
        occurrence def Context {
            doc
            /* Definition:
             * Conditions where a control action may be unsafe.
             * Context can be a state of the system or the state of the operational environment.
             *
             * Example:
             * Environmental Context = A road closure within a one way street.
             * System Context = An automated vehicle is in an emergency state.
             */
            ref occurrence envConRef : EnvironmentalCondition;
            ref occurrence sysConRef : SystemCondition;
        }
        occurrence contexts [*] : Context;
        occurrence def EnvironmentalCondition;
        occurrence environmentalConditions [*] : EnvironmentalCondition;
        occurrence def SystemCondition;
        occurrence systemConditions [*] : SystemCondition;
        enum def TypesOfCA {
            doc
            /* Definition:
             * Represents different types of how a control action can be unsafe.
             *
             * Example:
             * Teleoperator command is NotProvided.
             */
            NotProvided;
            Provided;
            ProvidedIncorrectly;
            ProvidedTooLate;
            ProvidedTooSoon;
            ProvidedOutOfOrder;
        }
        enum typesOfCAs [*] : TypesOfCA;
        occurrence def UnsafeControlAction {
            doc
            /* Definition:
             * Represents a control action that, in a particular context, will lead to a hazard, 
             * and may eventually, given worst-case environmental conditions, lead to losses.
             *
             * Model-Based Composition:
             * UCA = <Source> & <Type> & <ControlAction> & <Receiver> & <Context> & [Hazards]
             *
             * Example:
             * UCA = The <teleoperator> <does not provide> the <operation command> to the <automated vehicle> 
             * <during a complex traffic situation> leading to [H1 - the vehicle not being able to continue its mission].
             */
            ref part sourceRef [1] : ModelControlStructure::Controller, ModelControlStructure::Actuator;
            enum typeRef [1] : TypesOfCA;
            ref flow controlActionRef [1] : ModelControlStructure::ControlAction;
            ref part receiverRef [1] : ModelControlStructure::Process, ModelControlStructure::Controller;
            ref occurrence contextRef [1] : Context;
            ref occurrence hazardsRef [1..*] : DefineAnalysisPurpose::Hazard;
        }
        occurrence unsafeControlActions [*] : UnsafeControlAction;
        occurrence def UnwantedControlAction :> UnsafeControlAction;
        occurrence unwantedControlActions [*] : UnwantedControlAction;
        occurrence def UnsecureControlAction :> UnsafeControlAction;
        occurrence unsecureControlAction [*] : UnsecureControlAction;
    }
    package IdentifyLSs {
        doc
        /* This package contains the elements related to the fourth step of the STPA. 
         * The fourth step covers the identification of loss scenarios. 
         */
        occurrence def CausalFactor {
            doc
            /* Definition:
             * Represents a circumstance, fact, or influence contributing to a causal scenario. 
             * Causal factors can include: interactions, process models, contextual variables, etc.
             *
             * Example:
             * Interaction = <Teleoperator command> & <not forwarded>.
             * Process model = <Awareness of supervised vehicles> & <is incorrect>.
             */
            ref occurrence factorRef [1] : ModelControlStructure::ControlAction, ModelControlStructure::Feedback, ModelControlStructure::ProcessModel,
            ModelControlStructure::MentalModel, IdentifyUCAs::EnvironmentalCondition, IdentifyUCAs::SystemCondition;

            attribute status : String;
        }
        occurrence causalFactors [*] : CausalFactor;
        occurrence def LossScenario {
            doc
            /* Definition:
             * Represents the causal factors that can lead to unsafe control actions and to hazards.
             *
             * Model-Based Composition:
             * LS = <CausalFactors> & [UCAs]
             *
             * Example:
             * <Teleoperator command> & <not forwarded> leading to [UCA1]
             * <Awareness of supervised vehicles> & <is incorrect> leading to [UCA2]  
             */
            ref occurrence causalFactorsRef [1..*] : IdentifyLSs::CausalFactor;
            ref occurrence ucasRef [1..*] : IdentifyUCAs::UnsafeControlAction;
        }
        occurrence lossScenarios [*] : LossScenario;
    }
    package MetaTypesSTPA {
        doc /* This package contains all the meta types for the STPA library elements
         */
        #loss part lossExample;
        metadata def <loss> :> Metaobjects::SemanticMetadata {
            :>> baseType = DefineAnalysisPurpose::losses meta SysML::Systems::OccurrenceUsage;
        }
        #hazard part hazardExample;
        metadata def <hazard> :> Metaobjects::SemanticMetadata {
            :>> baseType = DefineAnalysisPurpose::hazards meta SysML::Systems::OccurrenceUsage;
        }
        #controlStructure part controlStructureExample;
        metadata def <controlStructure> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::controlStructures meta SysML::Systems::PartUsage;
        }
        #controller part controllerExample;
        metadata def <controller> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::controllers meta SysML::Systems::PartUsage;
        }
        #controllerHuman part controllerHumanExample;
        metadata def <controllerHuman> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::humanControllers meta SysML::Systems::PartUsage;
        }
        #actuator part actuatorExample;
        metadata def <actuator> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::actuators meta SysML::Systems::PartUsage;
        }
        #sensor part sensorExample;
        metadata def <sensor> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::sensors meta SysML::Systems::PartUsage;
        }
        #process part processExample;
        metadata def <process> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::processes meta SysML::Systems::PartUsage;
        }
        #controlAction flow controlActionExample;
        metadata def <controlAction> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::controlActions meta SysML::Systems::FlowUsage;
        }
        #feedback flow feedbackExample;
        metadata def <feedback> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::feedbacks meta SysML::Systems::FlowUsage;
        }
        #processModel part processModelExample;
        metadata def <processModel> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::processModels meta SysML::Systems::PartUsage;
        }
        #mentalModel part mentalModelExample;
        metadata def <mentalModel> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::mentalModels meta SysML::Systems::PartUsage;
        }
        #uca occurrence ucaExample;
        metadata def <uca> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyUCAs::unsafeControlActions meta SysML::Systems::OccurrenceUsage;
        }
        #envCon occurrence envConExample;
        metadata def <envCon> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyUCAs::environmentalConditions meta SysML::Systems::OccurrenceUsage;
        }
        #sysCon occurrence sysConExample;
        metadata def <sysCon> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyUCAs::systemConditions meta SysML::Systems::OccurrenceUsage;
        }
        #context occurrence contextExample;
        metadata def <context> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyUCAs::contexts meta SysML::Systems::OccurrenceUsage;
        }
        #cf occurrence causalFactorExample;
        metadata def <cf> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyLSs::causalFactors meta SysML::Systems::OccurrenceUsage;
        }
        #ls occurrence lossScenarioExample;
        metadata def <ls> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyLSs::lossScenarios meta SysML::Systems::OccurrenceUsage;
        }
    }
    package ViewsAndViewpoints {
        private import MetaTypesSTPA::*;
        doc /* This package contains all the views and viewpoints for the utilization of the STPA library elements
         */
        package DefineAnalysisPurposeViews {
            viewpoint DefineLosses {
                doc /* It should be possible to define and show all losses of the system of interest */
                view def LossTree {
                    doc /* A tree diagram is one possibility to create and manage losses */
                    satisfy DefineLosses;
                    render asTreeDiagram;
                    filter @loss;
                }
            }
            viewpoint DefineHazards {
                doc /* It should be possible to define and show all hazards of the system of interest */
                view def HazardTree {
                    doc /* A tree diagram is one possibility to create and manage hazards */
                    satisfy DefineHazards;
                    render asTreeDiagram;
                    filter @hazard;
                }
            }
            viewpoint MapLossesToHazards {
                doc /* It should be possible to map every loss to at least one hazard */
                view def LossesToHazardsMatrix {
                    doc
                    /* A relationship matrix is one possibility to create and manage relationships 
                     * between losses and hazards */
                    satisfy MapLossesToHazards;
                    filter @hazard or @loss;
                }
            }
        }
        package ModelControlStructureViews {
            viewpoint ModelControlStructure {
                doc
                /* It should be possible to model the control structure with elements 
                 * and interactions of the system of interest */
                view def ControlStructureInterconnection {
                    doc /* An interconnection diagram is one possibility to create and manage a control structure */
                    satisfy ModelControlStructure;
                    render asInterconnectionDiagram;
                    filter @controlStructure or @controller or @controllerHuman or @actuator or @process or @sensor or @controlAction or @feedback or @mentalModel or
                            @processModel;
                }
            }
        }
        package IdentifyUCAsViews {
            viewpoint DefineContext {
                doc /* It should be possible to define the context of the system of interest */
                view def ContextTable {
                    doc /* An element table is one possibility to create and manage the context */
                    satisfy DefineContext;
                    render asElementTable;
                    filter @context;
                }
            }
            viewpoint IdentifyUCAs {
                doc /* It should be possible to identify UCAs for the system of interest */
                view def UCAsTable {
                    doc /* An element table is one possibility to create and manage UCAs */
                    satisfy IdentifyUCAs;
                    render asElementTable;
                    filter @uca;
                }
            }
        }
        package IdentifyLSsViews {
            viewpoint IdentifyLSs {
                doc /* It should be possible to identify LSs for the system of interest */
                view def LSsTable {
                    doc /* An element table is one possibility to create and manage LSs */
                    satisfy IdentifyLSs;
                    render asElementTable;
                    filter @ls;
                }
            }
            viewpoint MapUCAsToLSs {
                doc /* It should be possible to map at least one UCA to each loss scenario */
                view def LSsToUCAsMatrix {
                    doc /* A relationship matrix is one possibility to create and manage relationships between LSs and UCAs */
                    satisfy MapUCAsToLSs;
                    filter @ls or @uca;
                }
            }
        }
    }
}